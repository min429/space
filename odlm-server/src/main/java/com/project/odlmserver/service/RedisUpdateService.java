package com.project.odlmserver.service;

import com.google.firebase.messaging.FirebaseMessagingException;
import com.project.odlmserver.domain.*;
import com.project.odlmserver.repository.ReservationTableRepository;
import com.project.odlmserver.repository.SeatCustomRedisRepository;
import com.project.odlmserver.repository.SeatRedisRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.stream.Collectors;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


@Service
@Transactional
@RequiredArgsConstructor
@EnableScheduling
public class RedisUpdateService {

    private final SeatCustomRedisRepository seatCustomRedisRepository;
    private final SeatRedisRepository seatRedisRepository;
    private final UsersService usersService;
    private final FCMService fcmService;
    private final MyPageService myPageService;
    private final ReservationTableRepository reservationTableRepository;

    // Logger 인스턴스 가져오기 1분마다 실행되는 지 로그를 보기위함임 나중엔 지움
    private static final Logger logger = LoggerFactory.getLogger(RedisUpdateService.class);

    @Scheduled(fixedRate = 60000) // 매 1분마다 실행 (6,0000ms ) = 60초
    public void myScheduledMethod() {

        logger.info("=====1분====");
        //redis가 where문을 지원하지 않아 전부 가져온다음에 userId가 null인 것을 가져옴
        List<Seat> allSeats = seatRedisRepository.findAll();
        



        List<Seat> leavedSeats = allSeats.stream()
                .filter(seat -> seat != null && seat.getLeaveId() != null)
                .collect(Collectors.toList());
        for (Seat seat : leavedSeats) {

            seatCustomRedisRepository.updateLeaveCount(seat.getSeatId(), seat.getLeaveCount()+1);

            //자리비움 시간이 60분이면
            if (seat.getLeaveCount() == seat.getMaxLeaveCount()) {
                depriveSeat(seat.getSeatId(), seat.getUserId());
                changeAuthority(seat.getSeatId(),seat.getLeaveId());
                myPageService.saveStudyLog(seat.getLeaveId(), StudyLog.StudyLogType.START);
            }

        }

        List<Seat> reservedSeats = allSeats.stream()
                .filter(seat -> seat != null && seat.getUserId() != null)
                .collect(Collectors.toList());
        // isUsed가 false이면 useCount의 값을 1 증가시키고, useCount가 20인 경우 경고 메서드 호출 ,useCount가 30인 경우 자리 박탈 메서드 호출
        for (Seat seat : reservedSeats) {
            seatCustomRedisRepository.updateDuration(seat.getSeatId(), seat.getDuration() + 1);

            //실제로 사용하는데 useCount가 0이 아니면 0으로 초기화
            if (seat.getIsUsed() && seat.getUseCount() != 0 )
                seatCustomRedisRepository.updateUseCount(seat.getSeatId(),0L);

            //실제로 안하면
            if (!seat.getIsUsed()) {

                //useCount의 값을 1초 증가시킨다.
                Long updatedUseCount = seat.getUseCount() + 1;
                seatCustomRedisRepository.updateUseCount(seat.getSeatId(), updatedUseCount);

                if (updatedUseCount == 20) {
                    // 경고 메서드 호출
                    warn(seat.getUserId());
                }

                else if (updatedUseCount == 30) {
                    //등급 하락 메서드 호출
                    gradeManage(seat.getUserId());
                    //자리 박탈 메서드 호출
                    depriveSeat(seat.getSeatId(), seat.getUserId());

                }
            }
        }

    }

    public void gradeManage(Long userId){
        Users user = usersService.findByUserId(userId);
        usersService.updateDepirveCount(user.getId());
        if (user.getDepriveCount() == 3L){
            usersService.updateGradeandReservationTimeandAwayTime(user.getId());
        }

    }

    public void warn(Long userId) {
        String userToken = usersService.findUserTokenById(userId);
        fcmService.sendNotification(userToken);
    }

    public void depriveSeat(Long seatId, Long userId) {

        Users user = usersService.findByUserId(userId);
        LocalDateTime currentDateTime = LocalDateTime.now();

        // 현재 날짜의 일을 가져옵니다.
        Long dayOfMonth = (long) currentDateTime.getDayOfMonth();

        Long maxReservationTime = 0L
                ;
        if (user.getGrade().equals(Grade.HIGH)){

            maxReservationTime = 960L;
        } else if (user.getGrade().equals(Grade.MIDDLE)) {
            maxReservationTime = 720L;
        }

        Long dailyStudyTime= myPageService.getDailyStudyTime(user.getId(), dayOfMonth);
        Long useReservationTime = maxReservationTime - dailyStudyTime;
        usersService.updateDailyReservationTime(userId , useReservationTime);
        reservationTableRepository.updateEndTimeByUserIdAndSeatId(userId, seatId, currentDateTime);

        seatCustomRedisRepository.deleteUserId(seatId, userId);
        seatCustomRedisRepository.updateUseCount(seatId, 0L);
        usersService.updateState(userId, STATE.RETURN);

    }

    public void changeAuthority(Long seatId, Long leavedId){

        Users user = usersService.findByUserId(leavedId);
        LocalDateTime currentDateTime = LocalDateTime.now();
        ReservationTable newReservation = ReservationTable.builder()
                .user(user)
                .seatId(seatId)
                .startTime(currentDateTime) // 현재 날짜와 시간으로 설정
                .endTime(null) // 기본값으로 설정, 필요에 따라 수정
                .build();

        reservationTableRepository.save(newReservation);
        seatCustomRedisRepository.updateUserId(seatId,leavedId);
        seatCustomRedisRepository.updateLeaveIdNull(seatId);
        seatCustomRedisRepository.updateLeaveCount(seatId,0L);
        usersService.updateState(leavedId, STATE.RESERVE);
    }

}

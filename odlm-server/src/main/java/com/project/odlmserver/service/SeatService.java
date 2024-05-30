package com.project.odlmserver.service;

import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalDateTime;
import com.project.odlmserver.controller.dto.board.BoardDto;
import com.project.odlmserver.controller.dto.seat.LeaveRequestDto;
import com.project.odlmserver.controller.dto.seat.ReserveRequestDto;
import com.project.odlmserver.controller.dto.seat.ReturnRequestDto;
import com.project.odlmserver.controller.dto.seat.SeatDto;
import com.project.odlmserver.domain.*;
import com.project.odlmserver.repository.ReservationTableRepository;
import com.project.odlmserver.repository.SeatCustomRedisRepository;
import com.project.odlmserver.repository.SeatRedisRepository;
import com.project.odlmserver.repository.StudyLogCustomRedisRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Slf4j
@Service
@Transactional
@RequiredArgsConstructor
public class SeatService {

    private final SeatCustomRedisRepository seatCustomRedisRepository;
    private final SeatRedisRepository seatRedisRepository;
    private final UsersService usersService;
    private final ReservationTableRepository reservationTableRepository;
    private final MyPageService myPageService;

    public void save(ReserveRequestDto reserveRequestDto) {
        Long seatId = reserveRequestDto.getSeatId();


        // reserveRequestDto.getSeatId() 대신에 테스트에 사용할 seatId를 넣어줍니다.
        Seat seat = seatRedisRepository.findById(seatId)
                .orElseGet(() -> new Seat(seatId, null, false, 0L, null, 0L, 0L, 0L));

        // 조회된 seat 객체가 null이 아닌지 확인합니다.
        System.out.println("============== "+seat.getSeatId() +"========== "+seat.getLeaveId() );
        
        Users user = usersService.findByUserId(reserveRequestDto.getUserId());

        if (user.getState() == STATE.LEAVE){
            throw new IllegalArgumentException("현재 사용자가 자리비움 상태이므로 예약이 불가능합니다.");
            
        }




        if(user.getState() == STATE.RESERVE) {
            throw new IllegalArgumentException("이미 다른 자리를 예약함");
        }



        if(seat.getUserId() != null){
            throw new IllegalArgumentException("사용중인 자리");
        }

        LocalDateTime currentDateTime = LocalDateTime.now();

        ReservationTable newReservation = ReservationTable.builder()
                .user(user)
                .seatId(reserveRequestDto.getSeatId())
                .startTime(currentDateTime) // 현재 날짜와 시간으로 설정
                .endTime(null) // 기본값으로 설정, 필요에 따라 수정
                .build();

        // Save the new ReservationTable object
        reservationTableRepository.save(newReservation);

        Seat.SeatBuilder seatBuilder = Seat.builder()
                .seatId(reserveRequestDto.getSeatId())
                .userId(user.getId())
                .isUsed(true)
                .useCount(0L)
                .duration(0L)
                .leaveCount(0L)
                .maxLeaveCount(0L);

        if (seat.getLeaveId() != null) {
            seatBuilder.leaveId(seat.getLeaveId());
        }

        Seat newSeat = seatBuilder.build();
        seatRedisRepository.save(newSeat);
        usersService.updateState(user.getId(), STATE.RESERVE);
    }



    public void returns(ReturnRequestDto returnRequestDto) {
        Users user = usersService.findByUserId(returnRequestDto.getUserId());
        Seat seat = seatRedisRepository.findByUserId(user.getId())
                .orElseThrow(() -> new IllegalArgumentException("이미 반납된 자리"));

        System.out.println(user.getId());
        System.out.println(seat.getUserId());
        if(!user.getId().equals(seat.getUserId())) {
            throw new IllegalArgumentException("예약자 본인 아님");
        }



        LocalDateTime currentDateTime = LocalDateTime.now();
        reservationTableRepository.updateEndTimeByUserIdAndSeatId(user.getId(), seat.getSeatId(), currentDateTime);

        // 현재 날짜의 일을 가져옵니다.
        Long dayOfMonth = (long) currentDateTime.getDayOfMonth();

        Long dailyStudyTime= myPageService.getDailyStudyTime(user.getId(), dayOfMonth);
        usersService.updateDailyReservationTime(user.getId() , dailyStudyTime);

        seatCustomRedisRepository.deleteUserId(seat.getSeatId(), seat.getUserId());
        usersService.updateState(user.getId(), STATE.RETURN);
    }

    public void leave(LeaveRequestDto leaveReauestDto) {
        Users user = usersService.findByUserId(leaveReauestDto.getUserId());
        Seat seat = seatRedisRepository.findByUserId(user.getId())
                .orElseThrow(() -> new IllegalArgumentException("이미 반납된 자리"));

        if(!user.getId().equals(seat.getUserId())) {
            throw new IllegalArgumentException("예약자 본인 아님");
        }
        if(user.getGrade() == Grade.LOW){
            throw new IllegalArgumentException("사용자의 등급이 LOW 등급임");
        }

        LocalDate currentDate = LocalDate.now();

        // 현재 날짜의 일을 가져옵니다.
        Long dayOfMonth = (long) currentDate.getDayOfMonth();

        Long dailyStudyTime= myPageService.getDailyStudyTime(user.getId(), dayOfMonth);
        usersService.updateDailyReservationTime(user.getId() , dailyStudyTime);
        usersService.updateDailyAwayTime(user.getId() , leaveReauestDto.getLeaveTime());

        seatCustomRedisRepository.updateMaxLeaveCount(seat.getSeatId(),leaveReauestDto.getLeaveTime());

        LocalDateTime currentDateTime = LocalDateTime.now();
        reservationTableRepository.updateEndTimeByUserIdAndSeatId(user.getId(), seat.getSeatId(), currentDateTime);

        seatCustomRedisRepository.updateLeaveId(seat.getSeatId(), seat.getUserId());
        seatCustomRedisRepository.deleteUserId(seat.getSeatId(), seat.getUserId());
        seatCustomRedisRepository.updateLeaveCount(seat.getSeatId(),0L);
        usersService.updateState(user.getId(), STATE.LEAVE);

    }

    public List<SeatDto> getAllSeats() {
        List<Seat> seats = seatRedisRepository.findAll();

        return seats.stream()
                .map(seat -> {
                    Long userId = seat.getUserId();
                    Long leaveId = seat.getLeaveId();

                    // BoardDto에 사용자의 이름을 포함하여 반환
                    return SeatDto.builder()
                            .seatId(seat.getSeatId())
                            .userId(userId)
                            .leaveId(leaveId)
                            .build();
                })
                .collect(Collectors.toList());
    }


}

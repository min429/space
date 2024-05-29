package com.project.odlmserver.service;

import com.project.odlmserver.controller.dto.board.BoardDto;
import com.project.odlmserver.controller.dto.user.*;
import com.project.odlmserver.domain.*;
import com.project.odlmserver.repository.ReservationTableRepository;
import com.project.odlmserver.repository.SeatRedisRepository;
import com.project.odlmserver.repository.UsersRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;


@Slf4j
@Service
@Transactional
@RequiredArgsConstructor
public class UsersService {

    private final UsersRepository usersRepository;
    private final SeatRedisRepository seatRepository;
    private final ReservationTableRepository reservationTableRepository;

    public void save(SignUpRequestDto signUpRequestDto) {
        Optional<Users> user = usersRepository.findByEmail(signUpRequestDto.getEmail());
        if (user.isPresent()) {
            throw new IllegalArgumentException("아이디 중복");
        }
        usersRepository.save(Users.builder()
                .email(signUpRequestDto.getEmail())
                .password(signUpRequestDto.getPassword())
                .name(signUpRequestDto.getName())
                .grade(Grade.HIGH)
                .state(STATE.RETURN)
                .dailyAwayTime(240L)
                .dailyReservationTime(960L)
                .build());
    }

    public Long login(LogInRequestDto signInRequestDto) {
        Users user = usersRepository.findByEmail(signInRequestDto.getEmail())
                .orElseThrow(() -> new IllegalArgumentException("아이디 불일치"));
        if (!signInRequestDto.getPassword().equals(user.getPassword())) {
            throw new IllegalArgumentException("비밀번호 불일치");
        }
        return user.getId();
    }

    public void delete(SignOutRequestDto signOutRequestDto) {
        Users users = usersRepository.findById(signOutRequestDto.getUserId())
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 유저"));
        usersRepository.delete(users);
    }

    public Users findByUserId(Long userId) {
        return usersRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 유저"));
    }

    public void updateState(Long userId, STATE state) {
        usersRepository.updateState(userId, state);
    }

    public Users findByEmail(String email) {
        return usersRepository.findByEmail(email)
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 유저"));
    }

    public String findUserTokenById(Long userId) {
        return usersRepository.findTokenByUserId(userId)
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 유저"));
    }


    public void updateToken(Long userId, String token) {
        usersRepository.updateToken(userId, token);
    }

    @Transactional
    @Scheduled(cron = "0 0 0 * * ?")
    public void performDailyTask() {
        usersRepository.updateAllTimesBasedOnGrade();
    }

    @Scheduled(cron = "0 0 0 1 * ?") // 매월 1일 0시에 실행
    public void resetAllUsersGradeAndTimes() {
        // 등급 및 시간을 초기화합니다.
        usersRepository.resetAllUsersGradeAndTimes(Grade.HIGH, 960L, 240L);
    }


    public MySeatDto findMySeat(MySeatRequestDto mySeatRequestDto) {
        Users user = usersRepository.findById(mySeatRequestDto.getUserId())
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 유저"));

        Optional<Seat> seatOptional = seatRepository.findByUserId(user.getId());
        

        if (seatOptional.isEmpty()) {
            seatOptional = seatRepository.findByLeaveId(user.getId());
        }


        if (seatOptional.isEmpty()) {
            throw new IllegalArgumentException("좌석 정보가 존재하지 않습니다");
        }

        Seat seat = seatOptional.get();

        return MySeatDto.builder()
                .userId(seat.getUserId())
                .seatId(seat.getSeatId())
                .name(user.getName())
                .dailyReservationTime(user.getDailyReservationTime())
                .dailyAwayTime(user.getDailyAwayTime())
                .grade(user.getGrade())
                .build();
    }

    public List<MyReservationTableDto> findMyReservationTable(MyReservationTableRequestDto myReservationTableRequestDto) {
        // 사용자 ID를 이용하여 예약 정보를 데이터베이스에서 가져옵니다.
        List<ReservationTable> reservationTables = reservationTableRepository.findByUserIdOrderByEndTimeDesc(myReservationTableRequestDto.getUserId());

        // 예약 정보를 DTO로 변환하여 반환합니다.
        return reservationTables.stream()
                .map(this::mapToDto)
                .collect(Collectors.toList());
    }

    private MyReservationTableDto mapToDto(ReservationTable reservationTable) {
        return MyReservationTableDto.builder()
                .userId(reservationTable.getUser().getId())
                .seatId(reservationTable.getSeatId())
                .startTime(reservationTable.getStartTime())
                .endTime(reservationTable.getEndTime())
                .build();
    }

    public void updateDepirveCount(Long userId){
        usersRepository.updateDepirveCount(userId,1);

    }

    public void updateGradeandReservationTimeandAwayTime(Long userId) {
        Users user = usersRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 유저"));

        // 현재 사용자의 등급을 확인하여 해당하는 조건에 따라 등급, dailyReservationTime 및 dailyAwayTime을 설정합니다.
        Grade newGrade;
        Long newReservationTime;
        Long newAwayTime;

        switch (user.getGrade()) {
            case HIGH:
                newGrade = Grade.MIDDLE;
                newReservationTime = 720L;
                newAwayTime = 180L;
                break;
            case MIDDLE:
                newGrade = Grade.LOW;
                newReservationTime = 0L;
                newAwayTime = 0L;
                break;
            // 만약 현재 등급이 LOW이면 추가적인 업데이트가 필요하지 않습니다.
            case LOW:
                return;
            default:
                throw new IllegalArgumentException("유효하지 않은 등급입니다");
        }

        // 등급 및 시간을 업데이트합니다.
        usersRepository.updateGradeAndTimes(userId, newGrade, newReservationTime, newAwayTime);
    }

    public void updateDailyAwayTime(Long userId, Long leaveTime){
        usersRepository.updateDailyAwayTime(userId , -leaveTime);
    }

    public void updateDailyReservationTime(Long userId, Long reservationTime) {
        usersRepository.updateDailyReservationTime(userId, -reservationTime);
    }

}



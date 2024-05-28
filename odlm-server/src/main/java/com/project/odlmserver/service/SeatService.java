package com.project.odlmserver.service;

import java.time.Duration;
import java.time.LocalDateTime;
import com.project.odlmserver.controller.dto.board.BoardDto;
import com.project.odlmserver.controller.dto.seat.LeaveRequestDto;
import com.project.odlmserver.controller.dto.seat.ReserveRequestDto;
import com.project.odlmserver.controller.dto.seat.ReturnRequestDto;
import com.project.odlmserver.controller.dto.seat.SeatDto;
import com.project.odlmserver.domain.*;
import com.project.odlmserver.repository.SeatCustomRedisRepository;
import com.project.odlmserver.repository.SeatRedisRepository;
import com.project.odlmserver.repository.StudyLogCustomRedisRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@Transactional
@RequiredArgsConstructor
public class SeatService {

    private final SeatCustomRedisRepository seatCustomRedisRepository;
    private final SeatRedisRepository seatRedisRepository;
    private final UsersService usersService;
    private final MyPageService myPageService;

    public void save(ReserveRequestDto reserveRequestDto) {
        Seat seat = seatRedisRepository.findById(reserveRequestDto.getSeatId())
                .orElseGet(() -> new Seat(reserveRequestDto.getSeatId(), null, false, 0L,null,0L,0L));

        Users user = usersService.findByUserId(reserveRequestDto.getUserId());
        if(user.getState() == STATE.RESERVE) {
            throw new IllegalArgumentException("이미 다른 자리를 예약함");
        }

        if(seat.getUserId() != null){
            throw new IllegalArgumentException("사용중인 자리");
        }

        Seat newSeat = new Seat(reserveRequestDto.getSeatId(), user.getId(), true, 0L,null,0L,0L);
        seatRedisRepository.save(newSeat);
        usersService.updateState(user.getId(), STATE.RESERVE);
    }

    public void returns(ReturnRequestDto returnRequestDto) {
        Users user = usersService.findByUserId(returnRequestDto.getUserId());
        Seat seat = seatRedisRepository.findByUserId(user.getId())
                .orElseThrow(() -> new IllegalArgumentException("이미 반납된 자리"));


        if(user.getId() != seat.getUserId()) {
            throw new IllegalArgumentException("예약자 본인 아님");
        }

        seatCustomRedisRepository.deleteUserId(seat.getSeatId(), seat.getUserId());
        usersService.updateState(user.getId(), STATE.RETURN);
    }

    public void leave(LeaveRequestDto leaveReauestDto) {
        Users user = usersService.findByUserId(leaveReauestDto.getUserId());
        Seat seat = seatRedisRepository.findByUserId(user.getId())
                .orElseThrow(() -> new IllegalArgumentException("이미 반납된 자리"));

        if(user.getId() != seat.getUserId()) {
            throw new IllegalArgumentException("예약자 본인 아님");
        }
        Long reservationTime;
        if(user.getGrade() == Grade.HIGH){
            reservationTime = 240L;
        }
        else if (user.getGrade() == Grade.MIDDLE){
            reservationTime = 180L;
        }
        else {
            throw new IllegalArgumentException("사용자의 현재 등급이 0므로 자리 비움이 불가능합니다.");
        }

        Long presentDuration = seat.getDuration();
        Long remainTime = reservationTime - presentDuration;
        if (remainTime < 60L) {
            throw new IllegalArgumentException("빌려주고도 남은시간이 1시간 이상이 아닙니다.");
        }


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


                    // BoardDto에 사용자의 이름을 포함하여 반환
                    return SeatDto.builder()
                            .seatId(seat.getSeatId())
                            .userId(userId)
                            .build();
                })
                .collect(Collectors.toList());
    }


}

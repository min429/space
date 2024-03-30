package com.project.odlmserver.service;

import com.project.odlmserver.controller.dto.ReserveRequestDto;
import com.project.odlmserver.controller.dto.ReturnRequestDto;
import com.project.odlmserver.domain.STATE;
import com.project.odlmserver.domain.Seat;
import com.project.odlmserver.domain.Users;
import com.project.odlmserver.repository.SeatCustomRedisRepository;
import com.project.odlmserver.repository.SeatRedisRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Service
@Transactional
@RequiredArgsConstructor
public class SeatService {

    private final SeatCustomRedisRepository seatCustomRedisRepository;
    private final SeatRedisRepository seatRedisRepository;
    private final UsersService usersService;

    public void save(ReserveRequestDto reserveRequestDto) {
        Optional<Seat> seat = seatRedisRepository.findById(reserveRequestDto.getSeatId());
        if (seat.isPresent()) {
            throw new IllegalArgumentException("자리 사용중");
        }

        Users user = usersService.findById(reserveRequestDto.getUserId());
        if(user.getState() == STATE.RESERVE) {
            throw new IllegalArgumentException("이미 다른 자리를 예약함");
        }

        Seat newSeat = new Seat(reserveRequestDto.getSeatId(), user.getId(), true, 0L);
        seatRedisRepository.save(newSeat);
        usersService.updateState(STATE.RESERVE);
    }

    public void returns(ReturnRequestDto returnRequestDto) {
        Users user = usersService.findById(returnRequestDto.getUserId());
        Seat seat = seatRedisRepository.findByUserId(user.getId())
                .orElseThrow(() -> new IllegalArgumentException("이미 반납된 자리"));

        if(user.getId() != seat.getUserId()) {
            throw new IllegalArgumentException("예약자 본인 아님");
        }

        seatCustomRedisRepository.deleteUserId(seat.getSeatId(), seat.getUserId());
        usersService.updateState(STATE.RETURN);
    }



}

package com.project.odlmserver.service;

import com.project.odlmserver.controller.dto.board.BoardDto;
import com.project.odlmserver.controller.dto.user.*;
import com.project.odlmserver.domain.Grade;
import com.project.odlmserver.domain.STATE;
import com.project.odlmserver.domain.Seat;
import com.project.odlmserver.domain.Users;
import com.project.odlmserver.repository.SeatRedisRepository;
import com.project.odlmserver.repository.UsersRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;


@Service
@Transactional
@RequiredArgsConstructor
public class UsersService {

    private final UsersRepository usersRepository;
    private final SeatRedisRepository seatRepository;

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

//    public Seat findMySeat(MySeatRequestDto mySeatRequestDto) {
//
//        return
//    }

    public void updateToken(Long userId, String token) {
        usersRepository.updateToken(userId, token);
    }

    @Transactional
    @Scheduled(cron = "0 0 0 * * ?")
    public void performDailyTask() {
        usersRepository.updateAllTimesBasedOnGrade();
    }


    public MySeatDto findMySeat(MySeatRequestDto mySeatRequestDto) {
        Users user = usersRepository.findById(mySeatRequestDto.getUserId())
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 유저"));

        Optional<Seat> seatOptional = seatRepository.findByUserId(user.getId());

        if (seatOptional.isEmpty()) {
            throw new IllegalArgumentException("좌석 정보가 존재하지 않습니다");
        }

        Seat seat = seatOptional.get();

        return MySeatDto.builder()
                .userId(user.getId())
                .seatId(seat.getSeatId())
                .name(user.getName())
                .dailyReservationTime(user.getDailyReservationTime())
                .dailyAwayTime(user.getDailyAwayTime())
                .grade(user.getGrade())
                .build();
    }

    }



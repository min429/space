package com.project.odlmserver.service;

import com.project.odlmserver.controller.dto.user.LogInRequestDto;
import com.project.odlmserver.controller.dto.user.SignUpRequestDto;
import com.project.odlmserver.domain.Grade;
import com.project.odlmserver.domain.STATE;
import com.project.odlmserver.domain.Users;
import com.project.odlmserver.repository.UsersRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;


@Service
@Transactional
@RequiredArgsConstructor
public class UsersService {

    private final UsersRepository usersRepository;

    public void save(SignUpRequestDto signUpRequestDto) {
        Optional<Users> user = usersRepository.findByEmail(signUpRequestDto.getEmail());
        if (user.isPresent()) {
            throw new IllegalArgumentException("아이디 중복");
        }
        usersRepository.save(Users.builder()
                .email(signUpRequestDto.getEmail())
                .password(signUpRequestDto.getPassword())
                .name(signUpRequestDto.getName())
                .grade(Grade.MIDDLE)
                .state(STATE.RETURN)
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

    public void delete(String email) {
        Users users = usersRepository.findByEmail(email)
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
}
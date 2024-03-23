package com.project.odlmserver.service;

import com.project.odlmserver.controller.dto.user.LogInRequestDto;
import com.project.odlmserver.controller.dto.user.SignUpRequestDto;
import com.project.odlmserver.domain.Grade;
import com.project.odlmserver.domain.Users;
import com.project.odlmserver.repository.UsersRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
@RequiredArgsConstructor
@Slf4j
public class UsersService {

    private final UsersRepository usersRepository;

    public void save(SignUpRequestDto signUpRequestDto) {
        usersRepository.findByEmail(signUpRequestDto.getEmail())
                .ifPresentOrElse((user) -> {
                    log.error("error");
                    throw new IllegalArgumentException("아이디 중복");
                }, () -> {
                    log.debug("success");
                    usersRepository.save(Users.builder()
                            .email(signUpRequestDto.getEmail())
                            .password(signUpRequestDto.getPassword())
                            .name(signUpRequestDto.getName())
                            .grade(Grade.MIDDLE)
                            .build());
                });
    }

    public String login(LogInRequestDto signInRequestDto){
        Users user = usersRepository.findByEmail(signInRequestDto.getEmail())
                .orElseThrow(() -> new IllegalArgumentException("아이디 불일치"));
        if(!signInRequestDto.getPassword().equals(user.getPassword())){
            throw new IllegalArgumentException("비밀번호 불일치");
        }
        return new String("로그인 성공");
    }

    public void delete(String email) {
        Users users = usersRepository.findByEmail(email)
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 유저"));
        usersRepository.delete(users);
    }
}

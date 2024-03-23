package com.project.odlmserver.service;

import com.project.odlmserver.repository.UsersRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UsersRepository usersRepository;


}

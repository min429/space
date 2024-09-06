package com.project.odlmserver.controller.dto.user;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class SignUpRequestDto {
    private String email;
    private String name;
    private String password;
}

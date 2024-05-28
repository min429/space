package com.project.odlmserver.controller.dto.user;

import com.project.odlmserver.domain.Grade;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class MySeatRequestDto {
    private Long userId;
}

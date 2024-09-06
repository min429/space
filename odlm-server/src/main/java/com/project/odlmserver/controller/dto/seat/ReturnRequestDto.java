package com.project.odlmserver.controller.dto.seat;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class ReturnRequestDto {
    private Long userId;
}

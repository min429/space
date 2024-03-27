package com.project.odlmserver.controller.dto;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class ReserveRequestDto {
    private Long seatId;
    private Long userId;
}

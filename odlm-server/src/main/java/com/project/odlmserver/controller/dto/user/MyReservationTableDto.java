package com.project.odlmserver.controller.dto.user;

import com.project.odlmserver.domain.Grade;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Getter
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class MyReservationTableDto {
    private Long userId;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private Long seatId;

    @Builder
    public MyReservationTableDto(Long userId, Long seatId, LocalDateTime startTime ,LocalDateTime endTime ) {
        this.userId = userId;
        this.seatId = seatId;
        this.startTime = startTime;
        this.endTime = endTime;
    }

}

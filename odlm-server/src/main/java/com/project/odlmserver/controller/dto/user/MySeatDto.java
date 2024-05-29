package com.project.odlmserver.controller.dto.user;

import com.project.odlmserver.domain.Grade;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class MySeatDto {
    private Long userId;
    private Long seatId;
    private Long leaveId;
    private String name;
    private Long dailyReservationTime;
    private Long dailyAwayTime;
    private Grade grade;

    @Builder
    public MySeatDto(Long userId, Long seatId, Long leaveId, String name, Long dailyReservationTime, Long dailyAwayTime, Grade grade) {
        this.userId = userId;
        this.seatId = seatId;
        this.leaveId = leaveId;
        this.name = name;
        this.dailyReservationTime = dailyReservationTime;
        this.dailyAwayTime = dailyAwayTime;
        this.grade = grade;
    }
}

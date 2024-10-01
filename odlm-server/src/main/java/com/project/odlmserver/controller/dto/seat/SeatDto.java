package com.project.odlmserver.controller.dto.seat;

import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class SeatDto {
    private Long seatId;
    private Long userId;
    private Long leaveId;
    private Long duration;
    private Long leaveCount;
}

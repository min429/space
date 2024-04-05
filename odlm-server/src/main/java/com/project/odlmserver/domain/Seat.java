package com.project.odlmserver.domain;

import lombok.*;
import org.springframework.data.annotation.Id;
import org.springframework.data.redis.core.RedisHash;
import org.springframework.data.redis.core.index.Indexed;

@Getter
@RedisHash("seat")
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder

public class Seat {

    @Id
    private Long seatId;

    @Indexed
    private Long userId;

    private Boolean isUsed; // 실제 사용 여부
    private Long useCount = 0L; // 사용 시간 카운트 (분 단위 측정)
}

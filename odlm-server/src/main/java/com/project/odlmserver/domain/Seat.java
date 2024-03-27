package com.project.odlmserver.domain;

import lombok.*;
import org.springframework.data.annotation.Id;
import org.springframework.data.redis.core.RedisHash;

@Getter
@RedisHash("seat")
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
public class Seat {

    @Id
    private Long seatId;

    private Boolean isReserved;

}

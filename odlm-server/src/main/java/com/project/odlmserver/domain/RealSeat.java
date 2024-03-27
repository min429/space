package com.project.odlmserver.domain;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.redis.core.RedisHash;

@Getter
@RedisHash("real_seat")
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class RealSeat {

    @Id
    private Long seatId;

    private Long userId;

}

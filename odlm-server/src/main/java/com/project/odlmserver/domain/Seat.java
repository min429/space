package com.project.odlmserver.domain;

import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import java.time.LocalDateTime;
import lombok.*;
import org.springframework.data.annotation.Id;
import org.springframework.data.redis.core.RedisHash;
import org.springframework.data.redis.core.index.Indexed;

@Getter
@RedisHash("seat")
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Seat {

    @Id
    private Long seatId;

    @Indexed
    private Long userId;

    private Boolean isUsed; // 실제 사용 여부
    private Long useCount = 0L; // 사용 시간 카운트 (분 단위 측정)

    private Long leaveId; //자리비움을 신청한 아이디

    private Long duration = 0L; // 자리 사용 기간 (분 단위)
    private Long leaveCount = 0L; //자리 비움 시간 카운트 (분 단위 측정)
    private Long maxLeaveCount;

    @Builder
    public Seat(Long seatId, Long userId, Boolean isUsed, Long useCount, Long leaveId, Long duration, Long leaveCount, Long maxLeaveCount) {
        this.seatId = seatId;
        this.userId = userId == null ? null : userId;
        this.isUsed = isUsed == null ? false : isUsed;
        this.useCount = useCount == null ? 0L : useCount;
        this.leaveId = leaveId == null ? null : leaveId;
        this.duration = duration == null ? 0L : duration;
        this.leaveCount = leaveCount == null ? 0L : leaveCount;
        this.maxLeaveCount = leaveCount == null ? null : leaveCount;
    }
}

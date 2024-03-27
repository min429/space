package com.project.odlmserver.domain;

import jakarta.persistence.*;
import lombok.*;
import org.springframework.data.redis.core.RedisHash;


@RedisHash("month_study")
@Getter @Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MonthStudy {

    @Id
    private Long id;

    private String month;

    private Long dailyStudyTime;
}

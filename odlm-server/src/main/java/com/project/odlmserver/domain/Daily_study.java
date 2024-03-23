package com.project.odlmserver.domain;

import jakarta.persistence.*;
import lombok.*;
import org.springframework.data.redis.core.RedisHash;

import java.util.Date;

@RedisHash("Daily_study")
@Getter @Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder

public class Daily_study {

    @Id
    private Long id;

    private String date;

    private int daily_study_time;

}

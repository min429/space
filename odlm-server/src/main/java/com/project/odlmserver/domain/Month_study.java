package com.project.odlmserver.domain;

import jakarta.persistence.*;
import lombok.*;
import org.springframework.data.redis.core.RedisHash;


@RedisHash("Month_study")
@Getter @Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Month_study {

    @Id
    private Long id;

    private String month;



    private Long daily_study_time;
}

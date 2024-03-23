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
    private String id; // Redis에 저장될 때 사용되는 식별자

    // Redis에 저장될 값들
    private Date date;

    private int studyTime;



}

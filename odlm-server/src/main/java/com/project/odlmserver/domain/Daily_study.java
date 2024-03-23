package com.project.odlmserver.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.util.Date;


@Entity
@Getter @Setter

public class Daily_study {

    @Id
    private int date;

    @Id
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "student_id")
    private Users users;

    private int daily_study_time;

}

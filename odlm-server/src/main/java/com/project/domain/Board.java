package com.project.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.sql.Date;
import java.time.LocalDateTime;


@Entity
@Getter @Setter

public class Board {
    @Id
    @Column(name = "board_id")
    private Long id;

    @Id
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "student_id")
    private Users user;

    @Lob
    private String content;
    private LocalDateTime post_time;

}

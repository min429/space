package com.project.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.sql.Date;


@Entity
@Getter @Setter

public class Board {
    @Id
    @Column(name = "board_id")
    private Long id;

    private Users user;

    private Lob content;
    private Date date;

}

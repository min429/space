package com.project.odlmserver.domain;


import jakarta.persistence.*;
import lombok.*;


@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Users {

    @Id
    @Column(name = "student_id")
    private Long id;

    @Column
    private String email;

    @Column
    private String password;

    @Column
    private String name;

    @Enumerated(EnumType.STRING)
    private Grade grade; //LOW, MIDDLE, HIGH
}

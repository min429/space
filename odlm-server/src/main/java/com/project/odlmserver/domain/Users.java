package com.project.odlmserver.domain;


import jakarta.persistence.*;
import lombok.*;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class Users {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "student_id")
    private Long id;

    @Column(nullable = false, unique = true)
    private String email;
    private String password;
    private String name;
    private Long seatId;

    @Enumerated(EnumType.STRING)
    private Grade grade; //LOW, MIDDLE, HIGH

    @Builder
    public Users(String email, String password, String name, Grade grade) {
        this.email = email;
        this.password = password;
        this.name = name;
        this.grade = grade;
    }
}

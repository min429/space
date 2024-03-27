package com.project.odlmserver.domain;


import jakarta.persistence.*;
import lombok.*;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Users {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "student_id")
    private Long id;

    @Column(nullable = false, unique = true)
    private String email;
    private String password;
    private String name;

    @Enumerated(EnumType.STRING)
    private STATE state; //RESERVE, RETURN, LEAVE

    @Enumerated(EnumType.STRING)
    private Grade grade; //LOW, MIDDLE, HIGH

    @Builder
    public Users(Long id, String email, String password, String name, Grade grade, STATE state) {
        this.id = id;
        this.email = email;
        this.password = password;
        this.name = name;
        this.grade = grade;
        this.state = state;
    }
}

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
    @GeneratedValue()
    @Column(name = "user_id")
    private Long id;

    @Column(nullable = false, unique = true)
    private String email;
    private String password;
    private String name;
    private String token;

    @Enumerated(EnumType.STRING)
    private STATE state; // RESERVE, RETURN, LEAVE

    @Enumerated(EnumType.STRING)
    private Grade grade; // LOW, MIDDLE, HIGH

    @Builder
    public Users(Long id, String email, String password, String name, Grade grade, STATE state, String token) {
        this.id = id;
        this.email = email;
        this.password = password;
        this.name = name;
        this.grade = grade;
        this.state = state;
        this.token = token;
    }
}

package com.project.odlmserver.controller.dto.board;

import com.project.odlmserver.domain.Board;
import com.project.odlmserver.domain.Users;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class BoardDto {
    private Long id;
    private String userName;
    private String content;
    private LocalDateTime postTime;

}
package com.project.odlmserver.controller.dto.board;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Getter
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class CreateBoardRequestDto {
    private Long boardId;
    private Long userId;
    private String content;
    private LocalDateTime postTime;
}

package com.project.odlmserver.controller.dto.board;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class DeleteBoardRequestDto {
    private Long id;
}

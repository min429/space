package com.project.odlmserver.controller.dto.mypage;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class AllMonthlyStudyRequestDto {
    private Long userId;
}

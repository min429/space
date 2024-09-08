package com.project.odlmserver.controller.dto.mypage;

import com.project.odlmserver.domain.Grade;
import com.project.odlmserver.domain.STATE;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@Builder
@AllArgsConstructor(access = AccessLevel.PRIVATE)
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class ReadProfileResponseDto {
	private String email;
	private String name;

	private STATE state; // RESERVE, RETURN, LEAVE

	private Grade grade; // LOW, MIDDLE, HIGH

	private Long dailyReservationTime; // 16, 12 ,0 실제로는 분으로 치환함 960, 720, 0
	private Long dailyAwayTime; //4, 3 , 0 실제로는 분으로 치환함 240, 180, 0

	private Long depriveCount;
}

package com.project.odlmserver.controller.dto.seat;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@Builder
@AllArgsConstructor(access = AccessLevel.PRIVATE)
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class ReadSeatResponseDto {
	private Long userId;

	private Boolean isUsed; // 실제 사용 여부
	private Long useCount = 0L; // 사용 시간 카운트 (분 단위 측정)

	private Long leaveId; //자리비움을 신청한 아이디

	private Long duration = 0L; // 자리 사용 기간 (분 단위)
	private Long leaveCount = 0L; //자리 비움 시간 카운트 (분 단위 측정)
	private Long maxLeaveCount;

	private Long studyTime = 0L;
}

package com.project.odlmserver.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

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

	private Long dailyReservationTime; // 16, 12 ,0 실제로는 분으로 치환함 960, 720, 0
	private Long dailyAwayTime; //4, 3 , 0 실제로는 분으로 치환함 240, 180, 0

	private Long depriveCount;

	private boolean warnAlert = true;
	private boolean returnAlert = true;

	@Builder
	public Users(Long id, String email, String password, String name, Grade grade, STATE state, String token,
		boolean warnAlert, boolean returnAlert) {
		this.id = id;
		this.email = email;
		this.password = password;
		this.name = name;
		this.grade = grade;
		this.state = state;
		this.token = token;
		this.warnAlert = warnAlert;
		this.returnAlert = returnAlert;
	}

	public void setWarnAlert(boolean warnAlert) {
		this.warnAlert = warnAlert;
	}

	public void setReturnAlert(boolean returnAlert) {
		this.returnAlert = returnAlert;
	}
}

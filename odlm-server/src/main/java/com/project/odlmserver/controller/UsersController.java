package com.project.odlmserver.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.project.odlmserver.controller.dto.user.LogInRequestDto;
import com.project.odlmserver.controller.dto.user.MyReservationTableDto;
import com.project.odlmserver.controller.dto.user.MyReservationTableRequestDto;
import com.project.odlmserver.controller.dto.user.MySeatDto;
import com.project.odlmserver.controller.dto.user.MySeatRequestDto;
import com.project.odlmserver.controller.dto.user.SignOutRequestDto;
import com.project.odlmserver.controller.dto.user.SignUpRequestDto;
import com.project.odlmserver.service.UsersService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/user")
@RequiredArgsConstructor
public class UsersController {

	private final UsersService userService;

	@PostMapping("/signup")
	public ResponseEntity<String> signup(@RequestBody SignUpRequestDto request) {
		userService.save(request);
		return ResponseEntity.ok().body("회원가입 성공");
	}

	@PostMapping("/login")
	public ResponseEntity<Long> login(@RequestBody LogInRequestDto request) {
		return ResponseEntity.ok().body(userService.login(request));
	}

	@PostMapping("/signout")
	public ResponseEntity<String> signout(@RequestBody SignOutRequestDto request) {
		userService.delete(request);
		return ResponseEntity.ok().body("회원탈퇴 완료");
	}

	@PostMapping("/myseat")
	public ResponseEntity<MySeatDto> myseat(@RequestBody MySeatRequestDto request) {
		MySeatDto mySeat = userService.findMySeat(request);
		return ResponseEntity.ok().body(mySeat);
	}

	@PostMapping("/myreservationtable")
	public ResponseEntity<List<MyReservationTableDto>> myreservationtable(
		@RequestBody MyReservationTableRequestDto request) {
		List<MyReservationTableDto> myReservationTables = userService.findMyReservationTable(request);
		return ResponseEntity.ok().body(myReservationTables);
	}

	@PatchMapping("/{id}/warn/{warn}")
	public ResponseEntity<Void> setWarnAlert(@PathVariable("id") Long userId, @PathVariable("warn") boolean state) {
		userService.updateWarnAlert(userId, state);
		return ResponseEntity.ok().build();
	}

	@PatchMapping("/{id}/return/{return}")
	public ResponseEntity<Void> setReturnAlert(@PathVariable("id") Long userId, @PathVariable("return") boolean state) {
		userService.updateReturnAlert(userId, state);
		return ResponseEntity.ok().build();
	}
}

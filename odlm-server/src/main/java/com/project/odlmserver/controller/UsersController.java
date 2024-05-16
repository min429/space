package com.project.odlmserver.controller;

import com.project.odlmserver.controller.dto.seat.SeatDto;
import com.project.odlmserver.controller.dto.user.LogInRequestDto;
import com.project.odlmserver.controller.dto.user.MySeatRequestDto;
import com.project.odlmserver.controller.dto.user.SignOutRequestDto;
import com.project.odlmserver.controller.dto.user.SignUpRequestDto;
import com.project.odlmserver.service.UsersService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

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

//    @GetMapping("/myseat")
//    public ResponseEntity<SeatDto> myseat(@RequestBody MySeatRequestDto request) {
//        return ResponseEntity.ok().body(userService.findMySeat(request));
//    }

}

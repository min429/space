package com.project.odlmserver.controller;

import com.project.odlmserver.controller.dto.seat.SeatDto;
import com.project.odlmserver.controller.dto.user.*;
import com.project.odlmserver.service.UsersService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
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

    @GetMapping("/myseat")
    public ResponseEntity<MySeatDto> myseat(@RequestBody MySeatRequestDto request) {
        MySeatDto mySeat = userService.findMySeat(request);
        return ResponseEntity.ok().body(mySeat);
    }

    @GetMapping("/myreservationtable")
    public ResponseEntity<List<MyReservationTableDto>> myreservationtable(@RequestBody MyReservationTableRequestDto request) {
        List<MyReservationTableDto> myReservationTables = userService.findMyReservationTable(request);
        return ResponseEntity.ok().body(myReservationTables);
    }

}

package com.project.odlmserver.controller;

import com.project.odlmserver.controller.dto.mypage.AllMonthlyStudyRequestDto;
import com.project.odlmserver.controller.dto.mypage.DailyStudyRequestDto;
import com.project.odlmserver.controller.dto.mypage.MonthlyStudyRequestDto;
import com.project.odlmserver.controller.dto.mypage.ReadProfileResponseDto;
import com.project.odlmserver.service.MyPageService;
import com.project.odlmserver.service.UsersService;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/mypage")
@RequiredArgsConstructor
public class MyPageController {

    private final MyPageService myPageService;
    private final UsersService usersService;

    @PostMapping("/day/{day}")
    public ResponseEntity<Long> getDailyStudyTime(@RequestBody DailyStudyRequestDto request, @PathVariable("day") Long day) {
        return ResponseEntity.ok().body(myPageService.getDailyStudyTime(request.getUserId(), day)); // 반환타입: 분
    }

    @PostMapping("/month/{month}")
    public ResponseEntity<Long> getMonthlyStudyTime(@RequestBody MonthlyStudyRequestDto request, @PathVariable("month") Long month) {
        return ResponseEntity.ok().body(myPageService.getMonthlyStudyTime(request.getUserId(), month)); // 반환타입: 분
    }

    @PostMapping("/monthly/all")
    public ResponseEntity<List<Long>> getAllMonthlyStudyTime(@RequestBody AllMonthlyStudyRequestDto request) {
        return ResponseEntity.ok().body(myPageService.getAllMonthlyStudyTime(request.getUserId())); // 반환타입: 분
    }

    @GetMapping("/{id}")
    public ResponseEntity<ReadProfileResponseDto> getAllMonthlyStudyTime(@PathVariable("id") Long userId) {
        return ResponseEntity.ok().body(usersService.getUserProfile(userId)); // 반환타입: 분
    }
}

package com.project.odlmserver.controller;

import com.project.odlmserver.service.MyPageService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/mypage")
@RequiredArgsConstructor
public class MyPageController {

    private final MyPageService myPageService;

    @PostMapping("/day/{day}")
    public ResponseEntity<Long> getDailyStudyTime(@RequestBody Long userId, @PathVariable Long day) {
        return ResponseEntity.ok().body(myPageService.getDailyStudyTime(userId, day)); // 반환타입: 분
    }

    @PostMapping("/month/{month}")
    public ResponseEntity<Long> getMonthlyStudyTime(@RequestBody Long userId, @PathVariable Long month) {
        return ResponseEntity.ok().body(myPageService.getMonthlyStudyTime(userId, month)); // 반환타입: 분
    }

    @PostMapping("/monthly/all")
    public ResponseEntity<List<Long>> getAllMonthlyStudyTime(Long userId) {
        return ResponseEntity.ok().body(myPageService.getAllMonthlyStudyTime(userId)); // 반환타입: 분
    }
}

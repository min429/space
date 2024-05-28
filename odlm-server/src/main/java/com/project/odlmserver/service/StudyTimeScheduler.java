package com.project.odlmserver.service;

import lombok.RequiredArgsConstructor;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;


@Component
@EnableScheduling
@RequiredArgsConstructor
public class StudyTimeScheduler {

    private final MyPageService myPageService;

    @Scheduled(cron = "0 0 0 1 * ?") // 매월 1일 0시 0분에 실행
    public void saveMonthlyStudyTime() {
        myPageService.saveMonthlyStudyTime();
    }
}

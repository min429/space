package com.project.odlmserver.repository;

import com.project.odlmserver.domain.Daily_study;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.time.LocalDateTime;
import java.util.Date;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
public class DSRepositoryTest {

    @Autowired
    private DSRepository dailyStudyRepository;

    @Test
    void testSaveDailyStudy() {
        // Daily_study 객체 생성
        Daily_study dailyStudy = Daily_study.builder()
                .date(new Date())
                .studyTime(60) // 예시로 60분으로 설정
                .build();

        // 저장
        dailyStudyRepository.save(dailyStudy);


    }
}
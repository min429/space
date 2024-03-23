package com.project.odlmserver.repository;

import com.project.odlmserver.domain.DailyStudy;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.Date;

@SpringBootTest
public class DSRepositoryTest {

    @Autowired
    private DSRedisRepository dailyStudyRepository;

    @Test
    void testSaveDailyStudy() {
        // Daily_study 객체 생성
        DailyStudy dailyStudy = DailyStudy.builder()
                .date(new Date())
                .studyTime(60) // 예시로 60분으로 설정
                .build();

        // 저장
        dailyStudyRepository.save(dailyStudy);


    }
}
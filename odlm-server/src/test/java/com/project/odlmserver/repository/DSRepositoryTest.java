package com.project.odlmserver.repository;


import com.project.odlmserver.domain.Seat;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;



@SpringBootTest
public class DSRepositoryTest {

    @Autowired
    private SeatRedisRepository seatRedisRepository;

    @Test
    void testSaveDailyStudy() {

        Seat seat = Seat.builder()
                .seatId(1L)
                .userId(1L)
                .isUsed(false)
                .useCount(0L)
                .build();

        // 저장
        seatRedisRepository.save(seat);


    }
}
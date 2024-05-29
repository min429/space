package com.project.odlmserver.repository;

import com.project.odlmserver.domain.Seat;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
public class SeatRepositoryTest {

    @Autowired
    private SeatRedisRepository seatRedisRepository;

    @Autowired
    private SeatCustomRedisRepository seatCustomRedisRepository;

    @Test
    void createSeat() {
        for(long i=1; i<=20; i++){
            seatRedisRepository.save(Seat.builder().seatId(i).userId(i).leaveId(i).build());
        }
        seatCustomRedisRepository.updateLeaveId(1L, 3L);
        seatCustomRedisRepository.updateLeaveIdNull(1L);
    }

    @Test
    void deleteSeat() {
        seatRedisRepository.deleteAll();
    }

}

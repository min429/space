package com.project.odlmserver.service;

import com.project.odlmserver.domain.Seat;
import com.project.odlmserver.domain.Users;
import com.project.odlmserver.repository.SeatCustomRedisRepository;
import com.project.odlmserver.repository.SeatRedisRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
@RequiredArgsConstructor
@EnableScheduling
public class RedisUpdateService {

    SeatCustomRedisRepository seatCustomRedisRepository;
    SeatRedisRepository seatRedisRepository;


    @Scheduled(fixedRate = 60000) // 매 1분마다 실행 (6,0000ms ) = 60초
    public void myScheduledMethod() {

        //userId가 NULL이 아닌 seat들을 리스트로 가져옴
        List<Seat> reservedSeats = seatRedisRepository.findAllByUserIdIsNotNull();

        // isUsed가 false이면 useCount의 값을 1 증가시키고, useCount가 20인 경우 경고 메서드 호출 ,useCount가 30인 경우 자리 박탈 메서드 호출
        for (Seat seat : reservedSeats) {

            //실제로 사용하는데 useCount가 0이 아니면 0으로 초기화
            if (seat.getIsUsed() && seat.getUseCount() != 0 )
                seatCustomRedisRepository.updateUseCount(seat.getSeatId(),0L);

            //실제로 안하면
            if (!seat.getIsUsed()) {

                //useCount의 값을 1초 증가시킨다.
                Long updatedUseCount = seat.getUseCount() + 1;
                seatCustomRedisRepository.updateUseCount(seat.getSeatId(), updatedUseCount);

                if (updatedUseCount == 20L) {
                    // 경고 메서드 호출
                    //warningMethod(users, seat);
                }

                else if (updatedUseCount == 30L) {
                    //자리 박탈 메서드 호출
                    //seatOutMethod(users, seat);
                }
            }
        }



    }


}

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
import java.util.stream.Collectors;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


@Service
@Transactional
@RequiredArgsConstructor
@EnableScheduling
public class RedisUpdateService {

    private final SeatCustomRedisRepository seatCustomRedisRepository;
    private final SeatRedisRepository seatRedisRepository;

    // Logger 인스턴스 가져오기 1분마다 실행되는 지 로그를 보기위함임 나중엔 지움
    private static final Logger logger = LoggerFactory.getLogger(RedisUpdateService.class);

    @Scheduled(fixedRate = 60000) // 매 1분마다 실행 (6,0000ms ) = 60초
    public void myScheduledMethod() {

        logger.info("=====1분====");
        //redis가 where문을 지원하지 않아 전부 가져온다음에 userId가 null인 것을 가져옴
        List<Seat> allSeats = seatRedisRepository.findAll();
        

        List<Seat> reservedSeats = allSeats.stream()
                .filter(seat -> {
                    Long userId = seat.getUserId();
                    String tempUserId = userId.toString();
                    return tempUserId != null && !tempUserId.isEmpty();
                })
                .collect(Collectors.toList());


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

                if (updatedUseCount == 20) {
                    // 경고 메서드 호출
                    //warningMethod(users, seat);
                }

                else if (updatedUseCount == 30) {
                    //자리 박탈 메서드 호출
                    //seatOutMethod(users, seat);
                }
            }
        }



    }


}

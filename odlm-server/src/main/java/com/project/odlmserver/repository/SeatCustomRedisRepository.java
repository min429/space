package com.project.odlmserver.repository;

import org.springframework.data.redis.core.HashOperations;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.SetOperations;
import org.springframework.stereotype.Repository;


@Repository
public class SeatCustomRedisRepository {

    private RedisTemplate<String, String> redisTemplate;
    private HashOperations<String, String, String> hashOperations;
    private SetOperations<String, String> setOperations;

    public SeatCustomRedisRepository(RedisTemplate<String, String> redisTemplate) {
        this.redisTemplate = redisTemplate;
        this.hashOperations = redisTemplate.opsForHash();
        this.setOperations = redisTemplate.opsForSet();
    }

    public void updateUserId(Long seatId, Long userId) {
        hashOperations.put("seat:" + seatId, "userId", userId.toString());
        hashOperations.put("seat:" + seatId, "useCount", "0");
        setOperations.remove("seat:userId:" + userId, seatId.toString());
        setOperations.add("seat:userId:" + userId, seatId.toString());
    }

    public void updateDuration(Long seatId, Long duration) {
        hashOperations.put("seat:" + seatId, "duration", duration.toString());
    }
    public void updateLeaveCount(Long seatId, Long leaveCount) {
        hashOperations.put("seat:" + seatId, "leaveCount", leaveCount.toString());
    }

    public void updateLeaveId(Long seatId, Long leaveId) {
        hashOperations.put("seat:" + seatId, "leaveId", leaveId.toString());
    }

    public void updateLeaveIdNull(Long seatId) {
        hashOperations.put("seat:" + seatId, "leaveId", "");
    }


    public void deleteUserId(Long seatId, Long userId) {
        hashOperations.put("seat:" + seatId, "userId", ""); // redis는 null 지원x
        hashOperations.put("seat:" + seatId, "useCount", "0"); // redis는 숫자 타입 지원x
        hashOperations.put("seat:" + seatId, "duration", "0"); // redis는 숫자 타입 지원x
        setOperations.remove("seat:userId:" + userId, seatId.toString());
    }

    public void updateUseCount(Long seatId, Long useCount) {
        hashOperations.put("seat:" + seatId, "useCount", useCount.toString());
    }
}

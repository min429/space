package com.project.odlmserver.repository;

import com.project.odlmserver.domain.Seat;
import org.springframework.data.redis.core.HashOperations;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.SetOperations;
import org.springframework.stereotype.Repository;


@Repository
public class SeatCustomRedisRepository {

    private RedisTemplate<String, Object> redisTemplate;
    private HashOperations<String, String, Object> hashOperations;
    private SetOperations<String, Object> setOperations;

    public SeatCustomRedisRepository(RedisTemplate<String, Object> redisTemplate) {
        this.redisTemplate = redisTemplate;
        this.hashOperations = redisTemplate.opsForHash();
        this.setOperations = redisTemplate.opsForSet();
    }

    public void updateUserId(Long seatId, Long userId) {
        hashOperations.put("seat:" + seatId, "userId", userId);
        setOperations.remove("seat:userId:" + userId, seatId.toString());
        setOperations.add("seat:userId:" + userId, seatId.toString());
    }

    public void deleteUserId(Long seatId, Long userId) {
        hashOperations.put("seat:" + seatId.toString(), "userId", null);
        setOperations.remove("seat:userId:" + userId, seatId.toString());
    }
}

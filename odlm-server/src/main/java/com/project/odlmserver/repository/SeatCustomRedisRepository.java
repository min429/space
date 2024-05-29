package com.project.odlmserver.repository;

import com.project.odlmserver.domain.Seat;
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
        Long beforeId = Long.valueOf(hashOperations.get("seat:" + seatId, "userId"));
        setOperations.pop("seat:userId:" + userId);
        setOperations.remove("seat:" + seatId + ":idx", "seat:userId:"+beforeId);
        hashOperations.put("seat:" + seatId, "userId", userId.toString());
        hashOperations.put("seat:" + seatId, "useCount", "0");
        setOperations.add("seat:userId:" + userId, seatId.toString());
        setOperations.add("seat:" + seatId + ":idx", "seat:userId:" + userId);
    }

    public void updateDuration(Long seatId, Long duration) {
        hashOperations.put("seat:" + seatId, "duration", duration.toString());
    }

    public void updateLeaveCount(Long seatId, Long leaveCount) {
        hashOperations.put("seat:" + seatId, "leaveCount", leaveCount.toString());
    }

    public void updateLeaveId(Long seatId, Long leaveId) {
        Long beforeId = Long.valueOf(hashOperations.get("seat:" + seatId, "leaveId"));
        setOperations.pop("seat:leaveId:" + leaveId);
        setOperations.remove("seat:" + seatId + ":idx", "seat:leaveId:"+beforeId);
        hashOperations.put("seat:" + seatId, "leaveId", leaveId.toString());
        setOperations.add("seat:leaveId:" + leaveId, seatId.toString());
        setOperations.add("seat:" + seatId + ":idx", "seat:leaveId:" + leaveId);
    }

    public void updateLeaveIdNull(Long seatId) {
        Long beforeId = Long.valueOf(hashOperations.get("seat:" + seatId, "leaveId"));
        setOperations.pop("seat:leaveId:" + beforeId);
        setOperations.remove("seat:" + seatId + ":idx", "seat:leaveId:"+beforeId);
        hashOperations.put("seat:" + seatId, "leaveId", "");
    }


    public void deleteUserId(Long seatId, Long userId) {
        Long beforeId = Long.valueOf(hashOperations.get("seat:" + seatId, "userId"));
        setOperations.pop("seat:userId:" + beforeId);
        setOperations.remove("seat:" + seatId + ":idx", "seat:userId:"+beforeId);
        hashOperations.put("seat:" + seatId, "userId", ""); // redis는 null 지원x
        hashOperations.put("seat:" + seatId, "useCount", "0"); // redis는 숫자 타입 지원x
        hashOperations.put("seat:" + seatId, "duration", "0"); // redis는 숫자 타입 지원x
    }

    public void updateUseCount(Long seatId, Long useCount) {
        hashOperations.put("seat:" + seatId, "useCount", useCount.toString());
    }

    public void updateMaxLeaveCount(Long seatId, Long maxLeaveCount) {
        hashOperations.put("seat:" + seatId, "maxLeaveCount", maxLeaveCount.toString());
    }
}

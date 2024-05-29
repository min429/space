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
        String id = hashOperations.get("seat:" + seatId, "userId");
        if(id != null){
            Long beforeId = Long.valueOf(id);
            setOperations.remove("seat:" + seatId + ":idx", "seat:userId:"+beforeId);
        }
        setOperations.pop("seat:userId:" + userId);
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
        String id = hashOperations.get("seat:" + seatId, "leaveId");
        if(id != null){
            Long beforeId = Long.valueOf(id);
            setOperations.remove("seat:" + seatId + ":idx", "seat:leaveId:"+beforeId);
        }
        setOperations.pop("seat:leaveId:" + leaveId);
        hashOperations.put("seat:" + seatId, "leaveId", leaveId.toString());
        setOperations.add("seat:leaveId:" + leaveId, seatId.toString());
        setOperations.add("seat:" + seatId + ":idx", "seat:leaveId:" + leaveId);
    }

    public void updateLeaveIdNull(Long seatId) {
        String id = hashOperations.get("seat:" + seatId, "leaveId");
        if(id != null){
            Long beforeId = Long.valueOf(id);
            setOperations.remove("seat:" + seatId + ":idx", "seat:leaveId:"+beforeId);
            setOperations.pop("seat:leaveId:" + beforeId);
        }
        hashOperations.put("seat:" + seatId, "leaveId", "");
    }


    public void deleteUserId(Long seatId, Long userId) {
        String id = hashOperations.get("seat:" + seatId, "userId");
        if(id != null){
            Long beforeId = Long.valueOf(id);
            setOperations.pop("seat:userId:" + beforeId);
            setOperations.remove("seat:" + seatId + ":idx", "seat:userId:"+beforeId);
        }
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

package com.project.odlmserver.repository;

import com.project.odlmserver.domain.StudyLog;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.ZSetOperations;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.util.Set;

import static com.project.odlmserver.domain.StudyLog.*;

@Repository
public class StudyLogCustomRedisRepository {

    private RedisTemplate<String, String> redisTemplate;
    private ZSetOperations<String, String> zSetOperations; // Sorted set

    public StudyLogCustomRedisRepository(RedisTemplate<String, String> redisTemplate) {
        this.redisTemplate = redisTemplate;
        this.zSetOperations = redisTemplate.opsForZSet();
    }

    public void save(StudyLog studyLog) {
        zSetOperations.add("study_log:" + studyLog.getUserId(), studyLog.getType().toString(), LocalDateTime.now().toEpochSecond(ZoneOffset.UTC)); // key, value, score(정렬 기준)
    }

    public Set<String> findAllByUserId(Long userId) {
        return zSetOperations.range("study_log:" + userId, 0, -1);
    }

    public StudyLog findLastByUserId(Long userId) {
        Set<ZSetOperations.TypedTuple<String>> studyLogs = zSetOperations.reverseRangeWithScores("study_log:" + userId, 0, 0); // 마지막 값
        if (studyLogs != null && !studyLogs.isEmpty()) {
            ZSetOperations.TypedTuple<String> lastLog = studyLogs.iterator().next();
            StudyLogType type = StudyLogType.valueOf(lastLog.getValue());
            LocalDateTime dateTime = LocalDateTime.ofEpochSecond(lastLog.getScore().longValue(), 0, ZoneOffset.UTC);
            return new StudyLog(userId, dateTime, type);
        }
        return null;
    }
}
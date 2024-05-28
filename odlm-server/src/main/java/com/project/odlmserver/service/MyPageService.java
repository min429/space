package com.project.odlmserver.service;

import com.project.odlmserver.domain.StudyLog;
import com.project.odlmserver.domain.StudyLog.StudyLogType;
import com.project.odlmserver.domain.daily.DailyStudy;
import com.project.odlmserver.domain.daily.DailyStudyId;
import com.project.odlmserver.domain.monthly.MonthlyStudy;
import com.project.odlmserver.domain.monthly.MonthlyStudyId;
import com.project.odlmserver.repository.DailyStudyRepository;
import com.project.odlmserver.repository.MonthlyStudyRepository;
import com.project.odlmserver.repository.StudyLogCustomRedisRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.Month;
import java.time.YearMonth;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@Transactional
@RequiredArgsConstructor
public class MyPageService {

    private final DailyStudyRepository dailyStudyRepository;
    private final MonthlyStudyRepository monthlyStudyRepository;
    private final StudyLogCustomRedisRepository studyLogCustomRedisRepository;

    public Long getDailyStudyTime(Long userId, Long day) {
        return dailyStudyRepository.findById(new DailyStudyId(userId, day))
                .orElseThrow(() -> new IllegalArgumentException(new StringBuilder().append(day).append("일 공부 시간 없음").toString())).getTime();
    }

    public Long getMonthlyStudyTime(Long userId, Long month) {
        return monthlyStudyRepository.findById(new MonthlyStudyId(userId, month))
                .orElseThrow(() -> new IllegalArgumentException(new StringBuilder().append(month).append("월 공부 시간 없음").toString())).getTime();
    }

    public List<Long> getAllMonthlyStudyTime(Long userId) {
        return monthlyStudyRepository.findByUserId(userId)
                .orElseThrow(() -> new IllegalArgumentException("전체 공부 시간 없음"))
                .stream()
                .map(MonthlyStudy::getTime)
                .collect(Collectors.toList());
    }

    public void saveDailyStudyTime(Long userId, LocalDateTime now){
        Long day = (long) now.getDayOfMonth();
        Long time = (long) now.getMinute()
                - studyLogCustomRedisRepository.findLastByUserId(userId).getDateTime().getMinute();

        dailyStudyRepository.save(new DailyStudy(new DailyStudyId(userId, day), time));
    }

    public void saveMonthlyStudyTime() {
        List<DailyStudy> dailyStudyTimes = dailyStudyRepository.findAll();

        Map<Long, Long> userStudyTimes = dailyStudyTimes.stream()
                .collect(Collectors.groupingBy(
                        dailyStudy -> dailyStudy.getId().getUserId(),
                        Collectors.summingLong(DailyStudy::getTime)
                )); // user별 학습량 총합

        Long month = (long) LocalDate.now().getMonthValue();

        userStudyTimes.forEach((userId, studyTime) ->
                monthlyStudyRepository.save(new MonthlyStudy(new MonthlyStudyId(userId, month), studyTime))
        );
    }

    public void saveStudyLog(Long userId, StudyLogType studyLogType) {
        LocalDateTime now = LocalDateTime.now();
        if(studyLogType == StudyLogType.END) saveDailyStudyTime(userId, now);
        studyLogCustomRedisRepository.save(new StudyLog(userId, now, studyLogType));
    }
}

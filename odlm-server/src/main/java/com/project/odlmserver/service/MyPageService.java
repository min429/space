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
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

@Service
@Transactional
@RequiredArgsConstructor
public class MyPageService {

    private final DailyStudyRepository dailyStudyRepository;
    private final MonthlyStudyRepository monthlyStudyRepository;
    private final StudyLogCustomRedisRepository studyLogCustomRedisRepository;

    public Long getDailyStudyTime(Long userId, Long day) {
        return dailyStudyRepository.findById(new DailyStudyId(userId, day))
                .map(DailyStudy::getTime)
                .orElse(0L);
    }

    public Long getMonthlyStudyTime(Long userId, Long month) {
        return monthlyStudyRepository.findById(new MonthlyStudyId(userId, month))
                .map(MonthlyStudy::getTime)
                .orElse(0L);
    }

    public List<Long> getAllMonthlyStudyTime(Long userId) {
        // 사용자 ID로 MonthlyStudy 목록을 가져옴
        List<MonthlyStudy> monthlyStudies = monthlyStudyRepository.findByIdUserId(userId)
                .orElseThrow(() -> new IllegalArgumentException("전체 공부 시간 없음"));

        // 1~12월을 위한 리스트 초기화 (모든 값을 0으로 설정)
        List<Long> monthlyTimes = IntStream.range(0, 12)
                .mapToObj(i -> 0L)
                .collect(Collectors.toList());

        // 각 MonthlyStudy 객체에 대해 해당 월의 시간을 리스트에 설정
        monthlyStudies.forEach(study -> {
            int monthIndex = study.getId().getMonth().intValue() - 1; // 월을 인덱스로 변환
            if (monthIndex >= 0 && monthIndex < 12) {
                monthlyTimes.set(monthIndex, study.getTime());
            }
        });

        return monthlyTimes;
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

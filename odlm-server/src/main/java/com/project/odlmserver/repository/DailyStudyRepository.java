package com.project.odlmserver.repository;

import com.project.odlmserver.domain.daily.DailyStudy;
import com.project.odlmserver.domain.daily.DailyStudyId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface DailyStudyRepository extends JpaRepository<DailyStudy, DailyStudyId> {
    Optional<List<DailyStudy>> findByIdUserId(Long userId);
}

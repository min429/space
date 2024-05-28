package com.project.odlmserver.repository;

import com.project.odlmserver.domain.monthly.MonthlyStudy;
import com.project.odlmserver.domain.monthly.MonthlyStudyId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface MonthlyStudyRepository extends JpaRepository<MonthlyStudy, MonthlyStudyId> {
    Optional<List<MonthlyStudy>> findByIdUserId(Long userId);
}

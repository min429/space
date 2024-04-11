package com.project.odlmserver.repository;

import com.project.odlmserver.domain.DailyStudy;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface DSRedisRepository extends CrudRepository<DailyStudy, Long> {

}
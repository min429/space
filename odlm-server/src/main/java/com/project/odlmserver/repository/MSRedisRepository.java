package com.project.odlmserver.repository;

import com.project.odlmserver.domain.MonthStudy;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface MSRedisRepository extends CrudRepository<MonthStudy, Long> {

}
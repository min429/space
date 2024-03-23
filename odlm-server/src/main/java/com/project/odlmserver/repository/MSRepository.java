package com.project.odlmserver.repository;

import com.project.odlmserver.domain.Month_study;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface MSRepository extends CrudRepository<Month_study, Long> {

}
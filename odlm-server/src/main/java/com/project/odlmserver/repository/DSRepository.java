package com.project.odlmserver.repository;

import com.project.odlmserver.domain.Daily_study;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface DSRepository extends CrudRepository<Daily_study, Long> {

}
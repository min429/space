package com.project.odlmserver.repository;

import com.project.odlmserver.domain.RealSeat;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface RealSeatRepository extends CrudRepository<RealSeat, Long> {
}

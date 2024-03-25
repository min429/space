package com.project.odlmserver.repository;

import com.project.odlmserver.domain.Seat;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface SeatRepository extends CrudRepository<Seat, Long> {
}

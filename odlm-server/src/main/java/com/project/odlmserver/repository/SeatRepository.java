package com.project.odlmserver.repository;

import com.project.odlmserver.domain.Seat;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface SeatRepository extends CrudRepository<Seat, Long> {

    Optional<Seat> findByUserId(Long userId);

    void updateUserId(Long seatId, Long userId);
}

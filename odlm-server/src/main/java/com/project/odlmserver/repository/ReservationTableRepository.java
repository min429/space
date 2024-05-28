package com.project.odlmserver.repository;

import com.project.odlmserver.domain.ReservationTable;
import com.project.odlmserver.domain.Users;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface ReservationTableRepository extends JpaRepository<ReservationTable, Long> {
    // Custom query methods can be defined here if needed
    List<ReservationTable> findByUserId(Long userId);

    List<ReservationTable> findByUserIdOrderByEndTimeDesc(Long userId);
    List<ReservationTable> findBySeatId(Long seatId);

    @Transactional
    @Modifying
    @Query("UPDATE ReservationTable r SET r.endTime = :endTime WHERE r.user.id = :userId AND r.seatId = :seatId AND r.endTime IS NULL")
    void updateEndTimeByUserIdAndSeatId(@Param("userId") Long userId, @Param("seatId") Long seatId, @Param("endTime") LocalDateTime endTime);
}


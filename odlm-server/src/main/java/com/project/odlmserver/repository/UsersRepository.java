package com.project.odlmserver.repository;

import com.project.odlmserver.domain.Users;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;


@Repository
public interface UsersRepository extends JpaRepository<Users, Long> {

    Optional<Users> findByEmail(String email);

    @Query("UPDATE Users u SET u.seatId = :seatId WHERE u.id = :id")
    void updateBySeatId(@Param("seatId") Long seatId, @Param("id") Long id);
}

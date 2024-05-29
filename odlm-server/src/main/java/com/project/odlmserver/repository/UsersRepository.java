package com.project.odlmserver.repository;

import com.project.odlmserver.domain.Grade;
import com.project.odlmserver.domain.STATE;
import com.project.odlmserver.domain.Users;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;


@Repository
public interface UsersRepository extends JpaRepository<Users, Long> {

    @Query("SELECT u.token FROM Users u WHERE u.id = :id")
    Optional<String> findTokenByUserId(@Param("id") Long userId);

    Optional<Users> findByEmail(String email);

    @Modifying(flushAutomatically = true, clearAutomatically = true)
    @Query("UPDATE Users u SET u.state = :state WHERE u.id = :id")
    void updateState(@Param("id") Long userId, @Param("state") STATE state);

    @Modifying(flushAutomatically = true, clearAutomatically = true)
    @Query("UPDATE Users u SET u.state = :state")
    void updateAllState(@Param("state") STATE state);

    @Modifying(flushAutomatically = true, clearAutomatically = true)
    @Query("UPDATE Users u SET u.token = :token WHERE u.id = :id")
    void updateToken(@Param("id") Long userId, @Param("token") String token);

    @Modifying(flushAutomatically = true, clearAutomatically = true)
    @Query("UPDATE Users u SET u.dailyReservationTime = :dailyReservationTime, u.dailyAwayTime = :dailyAwayTime WHERE u.id = :id")
    void updateTimes(@Param("id") Long userId, @Param("dailyReservationTime") Long dailyReservationTime, @Param("dailyAwayTime") Long dailyAwayTime);

    @Modifying(flushAutomatically = true, clearAutomatically = true)
    @Query("UPDATE Users u SET u.dailyReservationTime = CASE " +
            "WHEN u.grade = 'HIGH' THEN 960 " +
            "WHEN u.grade = 'MIDDLE' THEN 720 " +
            "WHEN u.grade = 'LOW' THEN 0 " +
            "END, " +
            "u.dailyAwayTime = CASE " +
            "WHEN u.grade = 'HIGH' THEN 240 " +
            "WHEN u.grade = 'MIDDLE' THEN 180 " +
            "WHEN u.grade = 'LOW' THEN 0 " +
            "END")
    void updateAllTimesBasedOnGrade();

    @Modifying(flushAutomatically = true, clearAutomatically = true)
    @Query("UPDATE Users u SET u.depriveCount = u.depriveCount + :count WHERE u.id = :userId")
    void updateDepirveCount(@Param("userId") Long userId, @Param("count") int count);

    @Modifying
    @Query("UPDATE Users u SET u.grade = :grade, u.dailyReservationTime = :reservationTime, u.dailyAwayTime = :awayTime WHERE u.id = :userId")
    void updateGradeAndTimes(@Param("userId") Long userId, @Param("grade") Grade grade, @Param("reservationTime") Long reservationTime, @Param("awayTime") Long awayTime);

    @Modifying
    @Query("UPDATE Users u SET u.grade = :grade, u.depriveCount = 0, u.dailyReservationTime = :reservationTime, u.dailyAwayTime = :awayTime")
    void resetAllUsersGradeAndTimes(@Param("grade") Grade grade, @Param("reservationTime") Long reservationTime, @Param("awayTime") Long awayTime);


    @Modifying
    @Query("UPDATE Users u SET u.dailyAwayTime = :leaveTime WHERE u.id = :userId")
    void updateDailyAwayTime(@Param("userId") Long userId,@Param("leaveTime")Long leaveTime);

    @Modifying
    @Query("UPDATE Users u SET u.dailyReservationTime = u.dailyReservationTime + :reservationTime WHERE u.id = :userId")
    void updateDailyReservationTime(@Param("userId") Long userId,@Param("reservationTime") Long reservationTime);
}

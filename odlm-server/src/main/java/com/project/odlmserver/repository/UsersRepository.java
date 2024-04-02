package com.project.odlmserver.repository;

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
}

package com.project.odlmserver.repository;

import com.project.odlmserver.domain.Users;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;


@Repository
public interface UsersRepository extends JpaRepository<Users, Long> {

}

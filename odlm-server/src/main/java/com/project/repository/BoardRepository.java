package com.project.repository;

import com.project.domain.Board;
import com.project.domain.Users;
import jakarta.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

@Repository
@RequiredArgsConstructor
public class BoardRepository {

    private final EntityManager em;


    public void save(Board board){
        em.persist(board);
    }

}

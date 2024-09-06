package com.project.odlmserver.repository;

import com.project.odlmserver.domain.Board;
import com.project.odlmserver.domain.Seat;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface BoardRepository  extends JpaRepository<Board, Long> {

    @Modifying
    @Query("UPDATE Board b SET b.content = :content , b.postTime = :postTime WHERE b.id = :boardId")
    void update(@Param("boardId") Long boardId, @Param("content") String content, @Param("postTime")LocalDateTime postTime);

    @Query(value = "SELECT * FROM board ORDER BY post_time DESC", nativeQuery = true)
    List<Board> findAllByOrderByPostTimeDesc();

}

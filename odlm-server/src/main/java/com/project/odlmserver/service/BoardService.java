package com.project.odlmserver.service;

import com.project.odlmserver.controller.dto.board.BoardDto;
import com.project.odlmserver.controller.dto.board.CreateBoardRequestDto;
import com.project.odlmserver.controller.dto.board.DeleteBoardRequestDto;
import com.project.odlmserver.controller.dto.board.UpdateBoardRequestDto;
import com.project.odlmserver.domain.Board;
import com.project.odlmserver.domain.Users;
import com.project.odlmserver.repository.BoardRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@Transactional
@RequiredArgsConstructor
public class BoardService {

    private final BoardRepository boardRepository;
    private final UsersService usersService;

    public void createBoard(CreateBoardRequestDto createBoardRequestDto) {



        Users findUser = usersService.findByUserId(createBoardRequestDto.getUserId());



        boardRepository.save(Board.builder()
                .user(findUser)
                .content(createBoardRequestDto.getContent())
                .postTime(LocalDateTime.now())
                .build());
    }

    public void updateBoard(UpdateBoardRequestDto updateBoardRequestDto) {
        Optional<Board> board = boardRepository.findById(updateBoardRequestDto.getBoardId());

        if (board.isEmpty()) {
            throw new IllegalArgumentException("업데이트를 할 게시글이 없습니다.");
        }
        Users findUser = usersService.findByUserId(updateBoardRequestDto.getUserId());

        Board newBoard = Board.builder()
                .id(updateBoardRequestDto.getBoardId())
                .user(findUser)
                .content(updateBoardRequestDto.getContent())
                .postTime(LocalDateTime.now())
                .build();

        boardRepository.update(newBoard.getId(),newBoard.getContent(),newBoard.getPostTime());

    }

    public void deleteBoard(DeleteBoardRequestDto deleteBoardRequestDto) {
        Optional<Board> boardOptional = boardRepository.findById(deleteBoardRequestDto.getBoardId());

        if (boardOptional.isEmpty()) {
            throw new IllegalArgumentException("이미 삭제된 게시글입니다.");
        }


        Board board = boardOptional.get(); // Optional에서 Board 객체 추출
        boardRepository.delete(board);
    }

    public List<BoardDto> getAllBoards() {
        List<Board> boards = boardRepository.findAllByOrderByPostTimeDesc();

        return boards.stream()
                .map(board -> {
                    Long userId = board.getUser().getId();
                    Users findUser = usersService.findByUserId(userId);

                    // BoardDto에 사용자의 이름을 포함하여 반환
                    return BoardDto.builder()
                            .id(board.getId())
                            .userEmail(findUser.getEmail())
                            .userName(findUser.getName()) // 사용자의 이름 설정
                            .content(board.getContent())
                            .postTime(board.getPostTime())
                            .build();
                })
                .collect(Collectors.toList());
    }

}

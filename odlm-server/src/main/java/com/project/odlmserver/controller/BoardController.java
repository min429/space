package com.project.odlmserver.controller;

import com.project.odlmserver.controller.dto.board.BoardDto;
import com.project.odlmserver.controller.dto.board.CreateBoardRequestDto;
import com.project.odlmserver.controller.dto.board.DeleteBoardRequestDto;
import com.project.odlmserver.controller.dto.board.UpdateBoardRequestDto;
import com.project.odlmserver.service.BoardService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/board")
@RequiredArgsConstructor
public class BoardController {

    private final BoardService boardService;

    @PostMapping("/create")
    public ResponseEntity<String> create(@RequestBody CreateBoardRequestDto request) {
        boardService.createBoard(request);
        return ResponseEntity.ok().body("게시판 글 생성 완료");
    }

    @PostMapping("/update")
    public ResponseEntity<String> update(@RequestBody UpdateBoardRequestDto request) {
        boardService.updateBoard(request);
        return ResponseEntity.ok().body("게시판 글 수정 완료");
    }

    @PostMapping("/delete")
    public ResponseEntity<String> delete(@RequestBody DeleteBoardRequestDto request) {
        boardService.deleteBoard(request);
        return ResponseEntity.ok().body("게시판 글 삭제 완료");
    }

    @GetMapping("/getAll")
    public ResponseEntity<List<BoardDto>> getAllBoards() {
        List<BoardDto> allBoards = boardService.getAllBoards();
        return ResponseEntity.ok().body(allBoards);
    }


}

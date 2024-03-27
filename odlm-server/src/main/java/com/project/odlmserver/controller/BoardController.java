package com.project.odlmserver.controller;

import com.project.odlmserver.controller.dto.ReserveRequestDto;
import com.project.odlmserver.controller.dto.ReturnRequestDto;
import com.project.odlmserver.controller.dto.board.CreateBoardRequestDto;
import com.project.odlmserver.controller.dto.board.DeleteBoardRequestDto;
import com.project.odlmserver.controller.dto.board.UpdateBoardRequestDto;
import com.project.odlmserver.service.BoardService;
import com.project.odlmserver.service.SeatService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/board")
@RequiredArgsConstructor
public class BoardController {

    private final BoardService boardService;

    @PostMapping("/create")
    public ResponseEntity<String> create(@RequestBody CreateBoardRequestDto request) {
        boardService.create(request);
        return ResponseEntity.ok().body("게시판 글 생성 완료");
    }

    @PostMapping("/update")
    public ResponseEntity<String> update(@RequestBody UpdateBoardRequestDto request) {
        boardService.updateBoard(request);
        return ResponseEntity.ok().body("게시판 글 수정 완료");
    }

    @PostMapping("/delete")
    public ResponseEntity<String> delete(@RequestBody DeleteBoardRequestDto request) {
        boardService.delete(request);
        return ResponseEntity.ok().body("게시판 글 삭제 완료");
    }


}

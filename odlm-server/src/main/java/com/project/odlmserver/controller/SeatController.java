package com.project.odlmserver.controller;

import com.project.odlmserver.controller.dto.board.BoardDto;
import com.project.odlmserver.controller.dto.seat.LeaveRequestDto;
import com.project.odlmserver.controller.dto.seat.ReserveRequestDto;
import com.project.odlmserver.controller.dto.seat.ReturnRequestDto;
import com.project.odlmserver.controller.dto.seat.SeatDto;
import com.project.odlmserver.service.SeatService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping( "/seat")
@RequiredArgsConstructor
public class SeatController {

    private final SeatService reservationService;

    @PostMapping("/reserve")
    public ResponseEntity<String> reserve(@RequestBody ReserveRequestDto request) {
        reservationService.save(request);
        return ResponseEntity.ok().body("예약 완료");
    }

    @PostMapping("/return")
    public ResponseEntity<String> returns(@RequestBody ReturnRequestDto request) {
        reservationService.returns(request);
        return ResponseEntity.ok().body("반납 완료");
    }

    @PostMapping("/leave")
    public ResponseEntity<String> returns(@RequestBody LeaveRequestDto request) {
        reservationService.leave(request);
        return ResponseEntity.ok().body("자리 비움 완료");
    }

    @GetMapping("/getAll")
    public ResponseEntity<List<SeatDto>> getAllSeats() {
        List<SeatDto> allSeats = reservationService.getAllSeats();
        return ResponseEntity.ok().body(allSeats);
    }



}

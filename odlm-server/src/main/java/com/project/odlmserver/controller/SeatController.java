package com.project.odlmserver.controller;

import com.project.odlmserver.controller.dto.ReserveRequestDto;
import com.project.odlmserver.controller.dto.ReturnRequestDto;
import com.project.odlmserver.service.SeatService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/seat")
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


}

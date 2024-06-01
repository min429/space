package com.project.odlmserver.controller;

import com.project.odlmserver.controller.dto.fcm.RegisterTokenRequestDto;
import com.project.odlmserver.service.FCMService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/fcm")
@RequiredArgsConstructor
public class FCMController {

    private final FCMService fcmService;

    @PostMapping("/register")
    public void registerToken(@RequestBody RegisterTokenRequestDto request) {
        fcmService.sendNotification(request.getToken());
        fcmService.registerToken(request.getUserId(), request.getToken());
    }
}

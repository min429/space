package com.project.odlmserver.service;

import com.google.firebase.messaging.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Slf4j
@Service
@RequiredArgsConstructor
public class FCMService {

    private final UsersService usersService;
    private final FirebaseMessaging firebaseMessaging;

    public void sendNotification(String userToken) {
        Message message = Message.builder()
                .setAndroidConfig(AndroidConfig.builder()
                        .setTtl(3600 * 1000) // 푸시알림을 fcm 서버에 한시간 보관
                        .setPriority(AndroidConfig.Priority.NORMAL)
                        .setNotification(AndroidNotification.builder()
                                .setTitle("자리를 비우셨나요?")
                                .setBody("10분 후 자동으로 자리가 반납됩니다.")
                                .setIcon("stock_ticker_update")
                                .setColor("#f45342")
                                .build())
                        .build())
                .setToken(userToken)
                .build();

        try{
            String response = firebaseMessaging.send(message);
            log.info("response: {}", response);
        }
        catch(FirebaseMessagingException e){
            log.error("error: {}", e);
        }
    }

    public void registerToken(Long userId, String token) {
        usersService.updateToken(userId, token);
    }
}

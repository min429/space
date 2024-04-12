package com.project.odlmserver;

import com.project.odlmserver.repository.SeatRedisRepository;
import com.project.odlmserver.service.FCMService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
public class NotificationTest {
    @Autowired
    private FCMService fcmService;

    @Test
    public void sendNotification(){
        String token = "fjUADZTAQTmgbQdsjiZ6fj:APA91bE3LUEJGRleXy_MpA889qWZHfRkh2l8bR34i20S4wkpbyZHnnQ-iwdqk8Mbqn5mQx_lZkZD-E3X4-H60RDtf44iZTHG7P1MVkyrV4ArYzdaltFvDc6-u6l5i4EAxIJjN-3lf8GK";
        fcmService.sendNotification(token);
    }
}

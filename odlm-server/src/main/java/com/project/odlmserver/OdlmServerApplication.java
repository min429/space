package com.project.odlmserver;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
public class OdlmServerApplication {

	public static void main(String[] args) {
		SpringApplication.run(OdlmServerApplication.class, args);
	}
}

package com.hanallym;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.session.jdbc.config.annotation.web.http.EnableJdbcHttpSession;

@SpringBootApplication
public class Application {
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}

//맨 처음 실행될 때 실행되는 메인 
//어플리케이션의 main문(내부 로직에 따라 웹서버, 사전 과정들을 모두 구축)
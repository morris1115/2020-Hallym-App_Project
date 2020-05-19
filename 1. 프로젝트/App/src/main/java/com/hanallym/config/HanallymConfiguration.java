package com.hanallym.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.session.jdbc.config.annotation.web.http.EnableJdbcHttpSession;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.util.Arrays;
import java.util.List;

@Configuration
@EnableJdbcHttpSession
public class HanallymConfiguration implements WebMvcConfigurer {


    @Override
    public void addInterceptors(InterceptorRegistry registry) {

        registry.addInterceptor(new LoginInterceptor())
                .addPathPatterns("/sign-in/**");

    }
}
//위의 두개의 파일을 설정을 해주는 것 로그인 하기 전에 로그인 하는 데이터를 제대로 갖고있는지 확인하고 로그인이 안되어있으면 로그인으로 되돌려보냄
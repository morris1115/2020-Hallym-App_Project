package com.hanallym.dto;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public class UserInfoDto {
    private int userIdx;
    private String userEmail;
    private String userPw;
    private String userName;
}

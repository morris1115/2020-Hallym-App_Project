package com.hanallym.repository;

import com.hanallym.domain.UserInfo;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserInfoRepository extends JpaRepository<UserInfo, Long> {
    UserInfo findByUserEmail(String userEmail);
    UserInfo findByUserIdx(int userIdx);
}
//서버에서 db로 쿼리를 보낼 때 sql이 아니라 코드로서 하게 해주는 것을 클래스로 표현하기 위해 만든 레파지토리

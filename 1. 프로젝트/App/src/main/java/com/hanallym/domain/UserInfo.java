package com.hanallym.domain;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.springframework.format.annotation.DateTimeFormat;

import javax.persistence.*;
import java.time.LocalDateTime;

@Getter
@NoArgsConstructor
@Entity
@Table(name = "user_info")
public class UserInfo {
    @Id
    @Column(name = "user_idx", nullable = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int userIdx;

    @Column(name = "user_email", length = 128, nullable = false)
    private String userEmail;

    @Column(name = "user_pw", nullable = false)
    private String userPw;

    @Column(name = "user_name", length = 32, nullable = false)
    private String userName;

    @Column
    @DateTimeFormat(pattern = "yyyy-MM-dd'T'hh:mm:ss")
    @CreationTimestamp
    private LocalDateTime create_date;

    @Builder
    public UserInfo(String userEmail, String userPw, String userName) {
        this.userEmail = userEmail;
        this.userPw = userPw;
        this.userName = userName;
    }

	public int getUserIdx() {
		return userIdx;
	}

	public String getUserEmail() {
		return userEmail;
	}

	public String getUserPw() {
		return userPw;
	}

	public String getUserName() {
		return userName;
	}

	public LocalDateTime getCreate_date() {
		return create_date;
	}
    
    
    
    
}

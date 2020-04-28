package com.hanallym.controller;

import com.hanallym.dto.UserInfoDto;


import com.hanallym.domain.UserInfo;

import com.hanallym.repository.UserInfoRepository;
import org.mindrot.jbcrypt.BCrypt;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;

@RestController
@SuppressWarnings("unchecked")
public class UserController {

    private final String USER = "user";

    @Autowired
    UserInfoRepository userDataRepository;

    @PostMapping("/sign-up")
    public ResponseEntity<HttpStatus> userSignUp(@RequestBody UserInfoDto userInfoDto) {
        if(userDataRepository.findByUserEmail(userInfoDto.getUserEmail()) != null)
            return new ResponseEntity<>(HttpStatus.CONFLICT); // 占쎌뵠筌롫뗄�뵬 餓λ쵎�궗

        UserInfo userData = new UserInfo(userInfoDto.getUserEmail(),
                BCrypt.hashpw(userInfoDto.getUserPw(), BCrypt.gensalt()),
                userInfoDto.getUserName());

        userDataRepository.save(userData);
        return new ResponseEntity<>(HttpStatus.OK);
    } //�쉶�썝媛��엯


    @PostMapping("/sign-in")
    public ResponseEntity<HttpStatus> userSignIn(@RequestBody UserInfoDto userInfoDto, HttpServletRequest request) {
        UserInfo userInfo = userDataRepository.findByUserEmail(userInfoDto.getUserEmail());

        if (BCrypt.checkpw(userInfoDto.getUserPw(), userInfo.getUserPw())) {
            request.getSession().setAttribute(USER, userInfo.getUserIdx());
            //model.addAttribute(USER, userInfoDto.getEmail());
            return new ResponseEntity<>(HttpStatus.OK);
        }else{
            //model.addAttribute(USER, userInfoDto.getEmail());
            return new ResponseEntity<>(HttpStatus.CONFLICT);
        }
    } 

    @GetMapping("/user/id/{userEmail}")
    public ResponseEntity<HttpStatus> isEmailExist(@PathVariable("userEmail") String userEmail) {
        UserInfo userInfo = userDataRepository.findByUserEmail(userEmail);
        try {
            if (userInfo.getUserEmail() == null) {
                return new ResponseEntity<>(HttpStatus.OK);
            } else {
                return new ResponseEntity<>(HttpStatus.CONFLICT);
            }
        }catch (NullPointerException e){
            return new ResponseEntity<>(HttpStatus.OK);
        }
    }

}



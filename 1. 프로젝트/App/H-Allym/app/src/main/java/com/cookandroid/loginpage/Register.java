package com.cookandroid.loginpage;

import androidx.appcompat.app.AppCompatActivity;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.Spinner;

import java.util.ArrayList;
import java.util.List;

public class Register extends AppCompatActivity {

    @SuppressLint("WrongViewCast")
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_register);

        EditText registerId, registerPassword, registerName, registerNumber;
        // 회원가입 Id, Password, 이름, 학번의 edittext 변수
        RadioGroup sexrGroup1; // 성별 라디오 버튼의 라디오 그룹 변수
        RadioButton rdoBtnMan, rdoBtnWoman; // 남녀 라디오 버튼 변수
        final Spinner spinner1,spinner2; // 소속 스피너 변수
        Button registerIdBtn, registerConfirmBtn, registerCancelBtn;
        // 중복확인, 확인, 취소 버튼 변수


        registerId = (EditText) findViewById(R.id.registerId); // 아이디
        registerPassword = (EditText) findViewById(R.id.registerPassword); // 비밀번호
        registerName = (EditText) findViewById(R.id.registerName); // 이름
        sexrGroup1 = (RadioGroup) findViewById(R.id.sexrGroup1); // 성별 라디오 그룹
        rdoBtnMan = (RadioButton) findViewById(R.id.rdoBtnMan); // 남성 라디오 버튼
        rdoBtnWoman = (RadioButton) findViewById(R.id.rdoBtnWoman); // 여성 라디오 버튼
        spinner1 = (Spinner) findViewById(R.id.spinner1); // 소속 스피너 버튼
        spinner2 = (Spinner) findViewById(R.id.spinner2);
        registerNumber = (EditText) findViewById(R.id.registerNumber); // 학번
        registerIdBtn = (Button) findViewById(R.id.registerBtn); // 중복확인 버튼
        registerConfirmBtn = (Button) findViewById(R.id.registerConfirmBtn); // 확인 버튼
        registerCancelBtn = (Button) findViewById(R.id.registerCancelBtn); // 취소 버튼




        final String [] majorList = {"소속학과 선택","경영학과","경제학과","간호학과","심리학과","빅데이터",
        "스마트IOT","콘텐츠IT","체육학과","의예과","철학과","광고홍보","국어국문","영어영문","러시아학과","사회학과","바이오메디컬"};
        // 스피너 버튼에 들어갈 리스트 목록
        List<String> spinnerArray = new ArrayList<String>();
        ArrayAdapter<String> adapter;
        adapter = new ArrayAdapter<String>(this, android.R.layout.simple_spinner_item, majorList);
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        spinner1.setAdapter(adapter); // 스피너 버튼 목록 출력


        // 회원 가입 레이아웃의 취소 버튼을 눌렀을 시 로그인 화면으로 전환
        registerCancelBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent registerIntent = new Intent(Register.this, LoginActivity.class);
                Register.this.startActivity(registerIntent);
            }
        });
    }
}

package com.cookandroid.loginpage;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import org.w3c.dom.Text;

public class LoginActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        EditText loginId, loginPassword; // 아이디, 비밀번호
        Button loginBtn; //로그인 버튼
        TextView findIdPwBtn, registerBtn; // 아이디,비밀번호 찾기 / 회원가입

        loginId = (EditText) findViewById(R.id.loginId); // 로그인 아이디
        loginPassword = (EditText) findViewById(R.id.loginPassword); // 로그인 비밀번호
        loginBtn = (Button) findViewById(R.id.loginBtn); // 로그인 버튼
        findIdPwBtn = (TextView) findViewById(R.id.findIdPwBtn); // 아이디,비밀번호 찾기
        registerBtn = (TextView) findViewById(R.id.registerBtn); // 회원가입


        registerBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent registerIntent = new Intent(LoginActivity.this, Register.class);
                LoginActivity.this.startActivity(registerIntent);
            }
        });
    }
}


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hanalarm/common/bbloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends BBloc {

  String _fcmToken;

  final GlobalKey<ScaffoldState> _scaffoldKey;

  final FirebaseMessaging _firebaseMessaging;

  final TextEditingController _textEditingControllerEmailLogin;
  final TextEditingController _textEditingControllerPasswordLogin;

  final TextEditingController _textEditingControllerEmailJoin;
  final TextEditingController _textEditingControllerPasswordJoin;
  final TextEditingController _textEditingControllerPasswordConfirmJoin;

  LoginBloc(BuildContext context)
    : _scaffoldKey = GlobalKey<ScaffoldState>(),

      _firebaseMessaging = FirebaseMessaging(),

      _textEditingControllerEmailLogin = TextEditingController(),
      _textEditingControllerPasswordLogin = TextEditingController(),

      _textEditingControllerEmailJoin = TextEditingController(),
      _textEditingControllerPasswordJoin = TextEditingController(),
      _textEditingControllerPasswordConfirmJoin = TextEditingController(),
      super(context) {
    add(BEvent("fcm_configure"));
  }

  @override /// 회원 가입을 위한 함수
  Stream<BState> mapEventToState(BEvent event) async * {
    switch (event.code) {
      case "fcm_configure":
        yield BState.deep(code: "progressing");

        _firebaseMessaging.configure(
          onMessage: (Map<String, dynamic> message) async {
            print("onMessage: $message");
//        _showItemDialog(message);
          },
          onLaunch: (Map<String, dynamic> message) async {
            print("onLaunch: $message");
//        _navigateToItemDetail(message);
          },
          onResume: (Map<String, dynamic> message) async {
            print("onResume: $message");
//        _navigateToItemDetail(message);
          },
        );

        _firebaseMessaging.getToken().then((fcmToken) {
          _fcmToken = fcmToken;
          add(BEvent("auto_login"));
        }).catchError((error) {
          _showSnackBar("FCM Token을 얻어올 수 없습니다", () {
            SystemNavigator.pop(animated: true);
          });
        });
        break;

      case "auto_login":
        yield BState.deep(code: "progressing");

        FirebaseAuth.instance.currentUser().then((user) {
          if (user != null) {
            add(BEvent("post_login", arguments: { "user": user }));
          } else {
            add(BEvent("wait_login"));
          }
        }).catchError((error) {
          _showSnackBar("로그인 할 수 없습니다", () {
            SystemNavigator.pop(animated: true);
          });
        });
        break;

      case "login":
        yield BState.deep(code: "progressing");

        FocusScope.of(context).requestFocus(FocusNode());
        
        String email = _textEditingControllerEmailLogin.text.trim();
        String password = _textEditingControllerPasswordLogin.text.trim();
        
        if (email.isEmpty) {
          _showSnackBar("이메일을 입력 해주세요", null);
          add(BEvent("wait_login"));
          return;
        }
        
        if (password.isEmpty) {
          _showSnackBar("비밀번호를 입력 해주세요", null);
          add(BEvent("wait_login"));
          return;
        }

        FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).then((authResult) {
          add(BEvent("post_login", arguments: { "user": authResult.user }));
        }).catchError((error) {
          switch (error.code) {
            case "ERROR_INVALID_EMAIL":
              _showSnackBar("옳바르지 않은 이메일 형식입니다", null);
              break;

            case "ERROR_WRONG_PASSWORD":
              _showSnackBar("비밀번호가 틀렸습니다", null);
              break;

            case "ERROR_USER_NOT_FOUND":
              _showSnackBar("존재하지 않는 이메일입니다", null);
              break;

            case "ERROR_USER_DISABLED":
              _showSnackBar("사용 정지된 이메일 입니다", null);
              break;

            case "ERROR_TOO_MANY_REQUESTS":
            case "ERROR_OPERATION_NOT_ALLOWED":
              _showSnackBar("로그인 할 수 없습니다", () {
                SystemNavigator.pop(animated: true);
              });
              return;
          }

          add(BEvent("wait_login"));
        });
        break;

      case "join":
        yield BState.deep(code: "progressing");

        FocusScope.of(context).requestFocus(FocusNode());

        String email = _textEditingControllerEmailJoin.text.trim();
        String password = _textEditingControllerPasswordJoin.text.trim();
        String passwordConfirm = _textEditingControllerPasswordConfirmJoin.text.trim();

        if (email.isEmpty) {
          _showSnackBar("이메일을 입력 해주세요", null);
          add(BEvent("wait_join"));
          return;
        }

        if (password.isEmpty || passwordConfirm.isEmpty) {
          _showSnackBar("비밀번호를 입력 해주세요", null);
          add(BEvent("wait_join"));
          return;
        }

        if (password != passwordConfirm) {
          _showSnackBar("두 비밀번호는 같아야 합니다", null);
          add(BEvent("wait_join"));
          return;
        }

        FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password).then((authResult) {
          add(BEvent("post_login", arguments: { "user": authResult.user }));
        }).catchError((error) {
          switch (error.code) {
            case "ERROR_WEAK_PASSWORD":
              _showSnackBar("더 강력한 비밀번호가 필요합니다", null);
              break;

            case "ERROR_INVALID_EMAIL":
              _showSnackBar("옳바르지 않은 이메일 입니다", null);
              break;

            case "ERROR_EMAIL_ALREADY_IN_USE":
              _showSnackBar("이미 가입된 이메일입니다", null);
              break;
          }

          add(BEvent("wait_join"));
        });
        break;

      case "wait_login":
        yield BState.deep(code: "wait_login");
        break;

      case "wait_join":
        yield BState.deep(code: "wait_join");
        break;

      case "post_login":
        Firestore.instance.collection("users").document(event.arguments["user"].uid).setData({
          "fcmToken": _fcmToken
        }).then((result) {
          Navigator.pushReplacementNamed(context, "home", arguments: event.arguments["user"]);
        }).catchError((error) {
          _showSnackBar("로그인 할 수 없습니다", null);
        });
        break;

      case "deep":
        yield BState.deep();
    }
  }

  void _showSnackBar(String message, void Function() onPress) {
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Container(
            child: Text(message),
            height: kToolbarHeight * 0.6,
            alignment: Alignment.centerLeft,),
          action: onPress != null ? SnackBarAction(
            onPressed: () {
              SystemNavigator.pop(animated: true);
            },
            label: "종료",
            textColor: Colors.white,
          ) : null,
          behavior: SnackBarBehavior.floating,
          duration: onPress != null ? Duration(days: 365) : Duration(milliseconds: 500),
        )
    );
  }

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  FirebaseMessaging get firebaseMessaging => _firebaseMessaging;

  TextEditingController get textEditingControllerEmailJoin => _textEditingControllerEmailJoin;
  TextEditingController get textEditingControllerPasswordJoin => _textEditingControllerPasswordJoin;
  TextEditingController get textEditingControllerPasswordConfirmJoin => _textEditingControllerPasswordConfirmJoin;

  TextEditingController get textEditingControllerEmailLogin => _textEditingControllerEmailLogin;
  TextEditingController get textEditingControllerPasswordLogin => _textEditingControllerPasswordLogin;
}
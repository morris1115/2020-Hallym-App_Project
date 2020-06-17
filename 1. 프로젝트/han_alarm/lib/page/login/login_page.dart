
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hanalarm/common/bbloc.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'login.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPage();
  }
}

class _LoginPage extends State<LoginPage> with TickerProviderStateMixin {
  LoginBloc _bloc;
  double _size;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = BlocProvider.of<LoginBloc>(context);
    _size = MediaQuery.of(context).size.width * 0.75;
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, BState>(
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            return true;
          },
          child: Scaffold(
            extendBody: true,
            key: _bloc.scaffoldKey,
            backgroundColor: Color(0xFF5B9BD5),
            body: SingleChildScrollView(child: _buildLogo(), padding: EdgeInsets.only(top: kToolbarHeight),),
            bottomNavigationBar: Wrap( // 로그인
              children: [
                Padding(
                  child: _buildInput(),
                  padding: EdgeInsets.only(left: kToolbarHeight / 2, right: kToolbarHeight / 2),
                ),
                Visibility(
                  visible: (_bloc.state.code == "wait_login") || (_bloc.state.code == "wait_join"),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: FlatButton(
                      onPressed: () {
                        switch (_bloc.state.code) {
                          case "wait_join":
                            _bloc.add(BEvent("join"));
                            break;

                          case "wait_login":
                            _bloc.add(BEvent("login"));
                            break;
                        }
                      },
                      color: Color(0xFFB3C6E6),
                      child: Container(
                        height: kToolbarHeight,
                        alignment: Alignment.center,
                        child: Text(_bloc.state.code == "wait_login" ? "로그인" : "회원가입", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500,fontFamily: "Jalnan"),),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
/// 로그인 화면
  Widget _buildInput() {
    switch (_bloc.state.code) {
      case "wait_login":
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: _bloc.textEditingControllerEmailLogin,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  labelText: "이메일",
                  labelStyle: TextStyle(
                      color: Colors.white, fontFamily: "Jalnan"
                  ),
                  focusColor: Colors.white,
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white))
              ),
              cursorColor: Colors.white,
              style: TextStyle(
                  color: Colors.white
              ),
            ),
            TextField( // 이메일과 비밀번호 로그인
              controller: _bloc.textEditingControllerPasswordLogin,
              obscureText: true,
              obscuringCharacter: "*",
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                  labelText: "비밀번호",
                  labelStyle: TextStyle(
                      color: Colors.white, fontFamily: "Jalnan"
                  ),
                  focusColor: Colors.white,
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white))
              ),
              cursorColor: Colors.white,
              style: TextStyle(
                  color: Colors.white
              ),
            ),
            Divider(color: Colors.transparent, height: 16,),
            FlatButton(
              onPressed: () {
                _bloc.add(BEvent("wait_join"));
              },
              clipBehavior: Clip.antiAlias,
              padding: EdgeInsets.only(top: 16, bottom: 16),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              child: Text("회원가입", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500, fontFamily: "Jalnan")),
            ),
            Divider(color: Colors.transparent, height: 16,),
          ],
        );
 /// 회원가입 레이아웃
      case "wait_join":
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: _bloc.textEditingControllerEmailJoin,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  labelText: "이메일",
                  labelStyle: TextStyle(
                      color: Colors.white, fontFamily: "Jalnan"
                  ),
                  focusColor: Colors.white,
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white))
              ),
              cursorColor: Colors.white,
              style: TextStyle(
                  color: Colors.white
              ),
            ),
            TextField(
              controller: _bloc.textEditingControllerPasswordJoin,
              obscureText: true,
              obscuringCharacter: "*",
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                  labelText: "비밀번호",
                  labelStyle: TextStyle(
                      color: Colors.white, fontFamily: "Jalnan"
                  ),
                  focusColor: Colors.white,
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white))
              ),
              cursorColor: Colors.white,
              style: TextStyle(
                  color: Colors.white
              ),
            ),
            TextField(
              controller: _bloc.textEditingControllerPasswordConfirmJoin,
              obscureText: true,
              obscuringCharacter: "*",
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                  labelText: "비밀번호 확인",
                  labelStyle: TextStyle(
                      color: Colors.white, fontFamily: "Jalnan"
                  ),
                  focusColor: Colors.white,
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white))
              ),
              cursorColor: Colors.white,
              style: TextStyle(
                  color: Colors.white
              ),
            ),
            Divider(color: Colors.transparent, height: 16,),
          ],
        );

      default:
        return Padding(
          child: SpinKitWave(color: Colors.white, ),
          padding: EdgeInsets.only(bottom: kToolbarHeight),
        );
    }
  }
/// 한알림 로고 함수
  Widget _buildLogo() { 
    return Container(
      color: Colors.transparent,
      alignment: Alignment.center,
      child: Card(
        elevation: 16,
        margin: EdgeInsets.all(32),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
            side: BorderSide(width: 8, color: Colors.white),
            borderRadius: BorderRadius.circular(_size / 2)),
        child: Container(
          color: Color(0xFFB4C7E7),
          alignment: Alignment.center,
          width: _size,
          height: _size,
          child: Column(
            children: <Widget>[
              Padding(padding: EdgeInsets.all(50.0)),
              Text("한 알 림",style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 64,fontFamily: "Jalnan", shadows: <Shadow>[
                Shadow(
                  offset: Offset(2.0, 2.0),
                  blurRadius: 8.0,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ]),),
              Padding(padding: EdgeInsets.all(5.0)),
              Text("한림 알림 울림",style: TextStyle(color: Colors.white, fontWeight: FontWeight.w100, fontSize: 30,fontFamily: "Jalnan"),
              )]
          )
        ),
      ),
    );
  }
}
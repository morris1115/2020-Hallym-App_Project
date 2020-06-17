
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hanalarm/common/bbloc.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'home.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePage();
  }
}

class _HomePage extends State<HomePage> with TickerProviderStateMixin {

  static final DateFormat DateFMT = DateFormat("yyyy-MM-dd"); // 공지사항 날짜

  HomeBloc _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = BlocProvider.of<HomeBloc>(context);
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
/// 공지사항을 띄우기 위한 메인화면
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, BState>(
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            return true;
          },
          child: DefaultTabController( // 메인화면 상단에 공지사항 카테고리별 선택을 위한 TabController
            length: 3, // TabController의 크기
            initialIndex: 0,
            child: Scaffold(
              key: _bloc.scaffoldKey,
              backgroundColor: Colors.white,
              appBar: AppBar( // 한알림 title을 가지고 있는 어플 상단의 AppBar
                centerTitle: true, // 가운데 정렬
                backgroundColor: Colors.white, // 배경색 흰색
                title: const Text("한 알 림", style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.w700, fontSize: 24, fontFamily: "Jalnan")),// 제목과 size설정
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(kToolbarHeight),
                  child: Container( // Container를 이용해 글을 가둬 가독성을 높인다.
                    alignment: Alignment.centerLeft,
                    child: TabBar(
                      isScrollable:  true,
                      // label들의 폰트와 크기, 색을 설정
                      labelStyle: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.w700, fontSize: 16, fontFamily: "Jalnan"),
                      unselectedLabelStyle: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.w100, fontSize: 16, fontFamily: "Jalnan"),
                      labelColor: Colors.blueGrey,
                      tabs: _bloc.homeTabs.map((homeTab) {
                        return Tab(text: homeTab.name,);
                      }).toList(),
                    ),
                  )
                ),
                iconTheme: IconThemeData(),
                actions: [
                  IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: () {
                      _bloc.scaffoldKey.currentState.openEndDrawer();
                    },
                  )
                ],
              ),
              /// 설정화면
              endDrawer: Drawer(
                child: SafeArea(
                  child: Column(
                    children: [
                      Container(
                        height: kToolbarHeight * 2.5,
                        padding: EdgeInsets.only(top: 16, left: 16, right: 8, bottom: 16),
                        child: Flex(
                          direction: Axis.vertical,
                          children: [
                            Flexible(
                              flex: 2,
                              fit: FlexFit.tight,
                              child: Container(
                                child: FlatButton(
                                  clipBehavior: Clip.antiAlias,
                                  onPressed: () async {
                                    await FirebaseAuth.instance.signOut();
                                    Navigator.pushReplacementNamed(context, "/");
                                  },
                                  child: Text("로그아웃", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14, fontFamily: "Jalnan")),
                                ),
                                alignment: Alignment.centerRight,
                              ),
                            ),
                            Flexible(
                              flex: 3,
                              fit: FlexFit.tight,
                              child: LayoutBuilder(builder: (context, constraints) {
                                double radius = constraints.maxHeight / 2;
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    CircleAvatar(
                                      radius: constraints.maxHeight / 2,
                                      backgroundColor: Colors.blueGrey,
                                      child: Text(_bloc.user.email.substring(0, 1), style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 24, fontFamily: "Jalnan")),
                                    ),
                                    VerticalDivider(width: 8, color: Colors.transparent,),
                                    Expanded(
                                      child: Text(_bloc.user.email, style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.w500, fontSize: 16, fontFamily: "Jalnan")),
                                    ),
                                  ],
                                );
                              },),
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 0, color: Colors.blueGrey,),
                      Expanded(
                        child: ListView(
                          children: [
                            ListTile(
                              onTap: () async {
                                String url = "mailto:baehongjun@kakao.com"; //관리자 메일 1대1문의
                                if (await canLaunch(url)) {
                                  launch(url);
                                }
                              },
                              title: Text("이메일 문의하기",style: TextStyle(fontFamily: "Jalnan"),),
                            ),
                            ListTile(
                              onTap: () async { // 카카오톡 문의
                                InAppBrowser.openWithSystemBrowser(url: "https://open.kakao.com/o/g6mp8Jac");
                              },
                              title: Text("카카오톡 오픈채팅",style: TextStyle(fontFamily: "Jalnan")),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              body: TabBarView(
                children: _bloc.homeTabs.map((homeTab) {
                  return homeTab.documents == null ?
                    Container(
                      alignment: Alignment.center,
                      child: SpinKitWave(color: Colors.deepOrangeAccent,),
                    ) :
                    RefreshIndicator(
                      onRefresh: homeTab.onRefresh,
                      child: ListView.separated(
                        controller: homeTab.scrollController,
                        itemCount: homeTab.documents.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot documentSnapshot = homeTab.documents.elementAt(index);

                          return ListTile(
                            onTap: () {
                              InAppBrowser().openUrl(
                                url: documentSnapshot["url"],
                                options: InAppBrowserClassOptions(
                                  crossPlatform: InAppBrowserOptions(
                                    hideUrlBar: true,
                                    toolbarTop: false,
                                  )
                                )
                              );
                            },
                            isThreeLine: false,
                            title: Text(documentSnapshot["title"], style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14, ),),
                            subtitle: Text(DateFMT.format(documentSnapshot["date"].toDate()) + " by " + documentSnapshot["writer"], style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 12, ),),
                            contentPadding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 0),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(height: 0,);
                        },
                      ),
                    );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}
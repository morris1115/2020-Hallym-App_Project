
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hanalarm/common/bbloc.dart';
import 'package:hanalarm/page/home/home.dart';

class HomeBloc extends BBloc {

  final FirebaseUser _user;
  final GlobalKey<ScaffoldState> _scaffoldKey;

  List<HomeTab> _homeTabs;

  HomeBloc(BuildContext context, FirebaseUser user)
    : _scaffoldKey = GlobalKey<ScaffoldState>(),
      _user = user,
      super(context) {

    _homeTabs = [ // TabBar 내용
      HomeTab(this, "한림대학교", "CrawlerUniversityWhole"),
      HomeTab(this, "소프트웨어 융합대학", "CrawlerCollegeSW2"),
      HomeTab(this, "소프트웨어 융합대학 사업단", "CrawlerCollegeSW"),
    ];
  }

  @override
  Stream<BState> mapEventToState(BEvent event) async * {
    switch (event.code) {
      case "deep":
        yield BState.deep();
    }
  }

  FirebaseUser get user => _user;
  List<HomeTab> get homeTabs => _homeTabs;
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;
}
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hanalarm/common/bbloc.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hanalarm/page/home/home.dart';

import 'page/login/login.dart';

Future<dynamic> backgroundFcmHandler(Map<String, dynamic> message) {
  if (message.containsKey('data')) {
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    final dynamic notification = message['notification'];
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(BlocProvider<AppBloc>(
    create: (context) => AppBloc(context),
    child: AppPage(),
  ));
}

class AppBloc extends BBloc {
  String _imei;

  AppBloc(BuildContext context) : super(context);

  String get imei => _imei;
  set imei(String value) {
    _imei = value;
  }
}

class AppPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AppPage();
  }
}

class _AppPage extends State<AppPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "NanumBarunPen",
      ),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: 0.9,
            highContrast: false,
            boldText: false,
          ),
          child: Container(
            color: Colors.black,
            child: child,
          ),
        );
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case "/":
            return CupertinoPageRoute(
                settings: settings,
                builder: (context) => BlocProvider<LoginBloc>(
                  create: (context) => LoginBloc(context),
                  child: LoginPage(),
                ));

          case "home":
            return CupertinoPageRoute(
                settings: settings,
                builder: (context) => BlocProvider<HomeBloc>(
                  create: (context) => HomeBloc(context, settings.arguments),
                  child: HomePage(),
                ));

          default:
            assert(false);
            return null;
        }
      },
    );
  }
}
import 'dart:async';

import 'package:chatapp/helper/TextPreferences.dart';
import 'package:chatapp/view/chat_home.dart';
import 'package:chatapp/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  String loggedEmail = "";
  @override
  void initState() {

    super.initState();
    Timer(Duration(seconds: 2), () async {
      loggedEmail = TextPreferences.getEmail();
      print('loggedEmail : $loggedEmail');
      if (loggedEmail!= "") {
        Navigator.pushReplacement(context, MaterialPageRoute<void>(
          builder: (BuildContext context) => ChatHome(),
        ));
      }else{
        Navigator.pushReplacement(context, MaterialPageRoute<void>(
          builder: (BuildContext context) => LoginScreen(),
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 200,
                width: 200,
                child: SvgPicture.asset('assets/splash.svg'),
              ),
              Text('Welcome to Chat App',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 18),)
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:chatapp/helper/app_theme_helper.dart';
import 'package:chatapp/helper/toast.dart';
import 'package:chatapp/view/chat_home.dart';
import 'package:chatapp/view/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../helper/TextPreferences.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<SignUp> {

  final emailController = TextEditingController();
  final userController = TextEditingController();
  final passwordController = TextEditingController();
  bool passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              name(),
              heightBox(10),
              username(),
              heightBox(10),
              password(),
              heightBox(10),
              loginButton(),
              InkWell(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => LoginScreen(),
                      ),
                    );
                  },
                  child: Text('Already have an account',style: TextStyle(color: Colors.blue),))
            ],
          ),
        ),
      ),
    );
  }

  Widget username() {
    return TextField(
        keyboardType: TextInputType.text,
        autofocus: false,
        maxLines: 1,
        maxLength: 20,
        controller: emailController,
        decoration: InputDecoration(
            hintText: 'Enter Email',
            counterText: "",
            prefixIcon: Icon(Icons.person, size: 18),
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32.0))));
  }

  Widget name() {
    return TextField(
        keyboardType: TextInputType.text,
        autofocus: false,
        maxLines: 1,
        maxLength: 20,
        controller: userController,
        decoration: InputDecoration(
            hintText: 'Enter name',
            counterText: "",
            prefixIcon: Icon(Icons.person, size: 18),
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32.0))));
  }

  Widget password() {
    return TextField(
        autofocus: false,
        obscureText: passwordVisible,
        controller: passwordController,
        maxLines: 1,
        maxLength: 20,
        decoration: InputDecoration(
            hintText:'Enter Password',
            counterText: "",
            prefixIcon: Icon(
              Icons.lock,
              size: 18,
            ),
            suffixIcon: InkWell(
                onTap: () {
                  setState(() {
                    passwordVisible = !passwordVisible;
                  });
                },
                child: Icon(
                    passwordVisible ? Icons.visibility : Icons.visibility_off)),
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32.0))));
  }

  Widget loginButton(){
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 12.0),
        child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            onPressed: () async {
              if (emailController.text.isEmpty || userController.text.isEmpty ||
                  passwordController.text.isEmpty) {
                Toast.show("Please Fill SignUp Details", context,
                    duration: 3,
                    gravity: Toast.bottom,
                    backgroundColor: Colors.black87.withOpacity(0.5),
                    textColor: Colors.white);
              }else if(passwordController.text.length < 6){
                Toast.show("Password can not be less than 6 char", context,
                    duration: 3,
                    gravity: Toast.bottom,
                    backgroundColor: Colors.black87.withOpacity(0.5),
                    textColor: Colors.white);
              } else {
                final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: emailController.text,
                    password: passwordController.text
                );

                Map<String,String> userDataMap = {
                  "userName" : userController.text,
                  "userEmail" : emailController.text
                };

                FirebaseFirestore.instance.collection('user').add(userDataMap).catchError((e) {
                  print(e.toString());
                });

                TextPreferences.setEmail(emailController.text);
                print(userCredential.user);
                Navigator.pushReplacement(context, MaterialPageRoute<void>(
                  builder: (BuildContext context) => ChatHome(),
                ));
              }
            },
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            color: Colors.lightBlue,
            child: Text('Create User',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700))));
  }
}

import 'package:chatapp/helper/TextPreferences.dart';
import 'package:chatapp/helper/app_theme_helper.dart';
import 'package:chatapp/helper/toast.dart';
import 'package:chatapp/view/chat_home.dart';
import 'package:chatapp/view/sign_up.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final userController = TextEditingController();
  final passwordController = TextEditingController();
  bool passwordVisible = true;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? user;

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
              username(),
              heightBox(10),
              password(),
              heightBox(10),
              loginButton(),
              heightBox(10),
              googleButton(),
              heightBox(10),
              InkWell(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => SignUp(),
                    ),
                  );
                },
                  child: Text('Don\'t Have an Account?',style: TextStyle(color: Colors.blue),))
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
        controller: userController,
        decoration: InputDecoration(
            hintText: 'Enter Email',
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
              if (userController.text.isEmpty ||
                  passwordController.text.isEmpty) {
                Toast.show("Please Fill Login Details", context,
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
                final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: userController.text,
                  password: passwordController.text
                );

                TextPreferences.setEmail(userController.text);
               Navigator.pushReplacement(context, MaterialPageRoute<void>(
                 builder: (BuildContext context) => ChatHome(),
               ));
              }
            },
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            color: Colors.lightBlue,
            child: Text('Log In',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700))));
  }

  Widget googleButton(){
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 12.0),
        child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            onPressed: () async {
              final googleUser = await _googleSignIn.signIn();

              if(googleUser == null) return;
              user = googleUser;

              final googleAuth = await googleUser.authentication;

              final creds = GoogleAuthProvider.credential(
                accessToken: googleAuth.accessToken,
                idToken: googleAuth.idToken
              );

              await FirebaseAuth.instance.signInWithCredential(creds);

              final currentUser = FirebaseAuth.instance.currentUser;
              print('currentUser : ${currentUser!.displayName}');
              TextPreferences.setEmail(currentUser.email!);

              Map<String,String> userDataMap = {
                "userName" : currentUser.displayName!,
                "userEmail" : currentUser.email!
              };

              FirebaseFirestore.instance.collection('user').add(userDataMap).catchError((e) {
                print(e.toString());
              });

              Navigator.pushReplacement(context, MaterialPageRoute<void>(
                builder: (BuildContext context) => ChatHome(isGoogleSignIn: true),
              ));
            },
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            color: Colors.green,
            child: Text('Log In with Google',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700))));
  }
}

import 'package:chatapp/helper/TextPreferences.dart';
import 'package:chatapp/helper/app_theme_helper.dart';
import 'package:chatapp/modal/usermodal.dart';
import 'package:chatapp/view/chat.dart';
import 'package:chatapp/view/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ChatHome extends StatefulWidget {
  bool? isGoogleSignIn = false;
  ChatHome({this.isGoogleSignIn});

  @override
  _ChatHomeState createState() => _ChatHomeState();
}

class _ChatHomeState extends State<ChatHome> {

  String userEmail = "";
  String loggedName = "";
  QuerySnapshot? searchResultSnapshot;
  List userList = [];
  List<user_modal>? alluserModal;
  List<user_modal>? userModal = [];
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void initState() {

    super.initState();
    userEmail = TextPreferences.getEmail();
    getUserData();
  }

  getUserData() async {
    await FirebaseFirestore.instance.collection('user')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        userList.add(doc.data());
        alluserModal = userList != null
            ? userList.map((i) => user_modal.fromJson(i)).toList()
            : [];
      });
    });

    for(int i=0;i<userList.length;i++){
      if(userEmail!= alluserModal![i].userEmail){
        userModal!.add(user_modal(
          userEmail: alluserModal![i].userEmail,
          userName: alluserModal![i].userName
        ));
      }
    }

    print('userList : $userList');
    for(int i=0;i<userList.length;i++){
      if(userEmail == alluserModal![i].userEmail){
        TextPreferences.setName(alluserModal![i].userName!);
      }
    }

    loggedName = TextPreferences.getName();
    print('logggedName : $loggedName');
    setState(() {
    });
    
  }

  sendMessage(String userName){
    List<String> users = [loggedName,userName];

    String chatRoomId = getChatRoomId(loggedName,userName);

    print(chatRoomId);
    Map<String, dynamic> chatRoom = {
      "users": users,
      "chatRoomId" : chatRoomId,
    };

    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .set(chatRoom)
        .catchError((e) {
      print(e);
    });

    Navigator.push(context, MaterialPageRoute(
        builder: (context) => Chat(
          chatRoomId: chatRoomId,
          userName: userName,
        )
    ));

  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat App'),
        actions: [
          GestureDetector(
            onTap: () async {
              TextPreferences.clearAllString();
              if(widget.isGoogleSignIn! != null && widget.isGoogleSignIn!){
                await _googleSignIn.signOut();
              }else{
                FirebaseAuth.instance.signOut();
              }
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.exit_to_app)),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(top: 10,left: 10,right: 10),
        child: userModal != null ? ListView.builder(
            itemCount: userModal?.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () async {
sendMessage(userModal![index].userName!);
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Material(
                    color: Colors.white,
                    elevation: 10,
                    borderRadius: BorderRadius.circular(12),
                    shadowColor: Colors.white60,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                color:
                                Colors.blue.withOpacity(0.8),
                                borderRadius:
                                BorderRadius.circular(8)),
                            child: Center(
                              child: Text(
                                '${userModal![index].userName![0]}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                          widthBox(10),
                          Container(
                            //width: MediaQuery.of(context).size.width - 120,
                            child: Container(
                              child: Text(
                                '${userModal![index].userName}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }) : Container(),
      ),
    );
  }
}

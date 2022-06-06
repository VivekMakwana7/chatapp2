import 'package:chatapp/helper/TextPreferences.dart';
import 'package:chatapp/helper/app_theme_helper.dart';
import 'package:chatapp/modal/chat_modal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  final String? chatRoomId;
  final String? userName;

  Chat({this.chatRoomId, this.userName});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  final messController = TextEditingController();

  Stream<QuerySnapshot>? getChatData;

  String? loggedEmail = "";
  String? loggedName = "";

  List chatList = [];
  List<chat_modal>? chatModal;

  Widget ChatList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("chatRoom")
          .doc(widget.chatRoomId)
          .collection("chats")
          .orderBy('time')
          .snapshots(),
      builder: (context, snapshot) {
        snapshot.hasData ? print(snapshot.data!) : print(
            'No Data');
        return snapshot.data != null ? snapshot.hasData ? ListView.builder(
          shrinkWrap: true,
            //physics: NeverScrollableScrollPhysics(),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              print(snapshot.data!.docs[index]['message']);
              print(snapshot.data!.docs[index]['sendBy']);
              return MessageTile(
                message: snapshot.data!.docs[index]['message'],
                sendByMe: loggedName == snapshot.data!.docs[index]['sendBy'],
              );
            }) : Container() : Container();
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loggedEmail = TextPreferences.getEmail();
    loggedName = TextPreferences.getName();
  }


  sendMess() {
    if (messController.text != "") {
      Map<String, dynamic> chatMessageMap = {
        "sendBy": loggedName,
        "message": messController.text,
        'time': DateTime
            .now()
            .millisecondsSinceEpoch,
      };

      FirebaseFirestore.instance.collection("chatRoom")
          .doc(widget.chatRoomId)
          .collection("chats")
          .add(chatMessageMap);

      messController.text = "";
      setState(() {

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('${widget.userName}'),
        ),
        body: Container(
          child: Stack(
            children: [
              ChatList(),
              Container(),
              Positioned(
                  bottom: 0,
                child: Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    height: 70,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      color: Colors.blue,
                      child: Row(
                        children: [
                          Expanded(
                              child: TextField(
                                controller: messController,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                                decoration: InputDecoration(
                                    hintText: "Message ...",
                                    hintStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                    border: InputBorder.none
                                ),
                              )),
                          SizedBox(width: 16,),
                          GestureDetector(
                            onTap: () {
                              sendMess();
                            },
                            child: Container(
                                child: Center(child: Icon(Icons.send))),
                          ),
                        ],
                      ),
                    ),
                  ),
              ),
            ],
          ),
        ),
      // bottomNavigationBar: Container(alignment: Alignment.bottomCenter,
      //   width: MediaQuery
      //       .of(context)
      //       .size
      //       .width,
      //   height: 70,
      //   child: Container(
      //     padding: EdgeInsets.symmetric(horizontal: 24),
      //     color: Colors.blue,
      //     child: Row(
      //       children: [
      //         Expanded(
      //             child: TextField(
      //               controller: messController,
      //               style: TextStyle(
      //                 color: Colors.white,
      //                 fontSize: 16,
      //               ),
      //               decoration: InputDecoration(
      //                   hintText: "Message ...",
      //                   hintStyle: TextStyle(
      //                     color: Colors.white,
      //                     fontSize: 16,
      //                   ),
      //                   border: InputBorder.none
      //               ),
      //             )),
      //         SizedBox(width: 16,),
      //         GestureDetector(
      //           onTap: () {
      //             sendMess();
      //           },
      //           child: Container(
      //               child: Center(child: Icon(Icons.send))),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}


class MessageTile extends StatelessWidget {
  final String? message;
  final bool? sendByMe;

  MessageTile({@required this.message, @required this.sendByMe});

  @override
  Widget build(BuildContext context) {
    print('message : $message');
    return Container(
        padding: EdgeInsets.only(
            top: 8,
            bottom: 8,
            left: sendByMe! ? 0 : 24,
            right: sendByMe! ? 24 : 0),
        alignment: sendByMe! ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(margin: sendByMe!
            ? EdgeInsets.only(left: 30)
            : EdgeInsets.only(right: 30),
            padding: EdgeInsets.only(
                top: 17, bottom: 17, left: 20, right: 20),
            decoration: BoxDecoration(
                borderRadius: sendByMe! ? BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomLeft: Radius.circular(23)
                ) :
                BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomRight: Radius.circular(23)),
                gradient: LinearGradient(
                  colors: sendByMe! ? [
                    const Color(0xff007EF4),
                    const Color(0xff2A75BC)
                  ]
                      : [
                    const Color(0xff007EF4).withOpacity(0.5),
                    const Color(0xfff)
                  ],
                )
            ),child: Text(message!)),
    );

    }
}


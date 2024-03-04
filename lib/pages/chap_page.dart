import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';
import 'package:vm_chat_app/pages/home_page.dart';
import 'package:vm_chat_app/service/dataabase.dart';
import 'package:vm_chat_app/service/shared_pref.dart';

// ignore: must_be_immutable
class ChatPage extends StatefulWidget {
  String name, profileurl, username;
  ChatPage(
      {super.key,
      required this.name,
      required this.profileurl,
      required this.username});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController messageController = TextEditingController();
  String? myUserName, myProfilePic, myName, myEmail, messageId, chatRoomId;
  Stream? messageStream;

  getTheSharedpref() async {
    myUserName = await SharedPreferenceHelper().getUseName();
    myProfilePic = await SharedPreferenceHelper().getUsePic();
    myEmail = await SharedPreferenceHelper().getUseEmail();
    myName = await SharedPreferenceHelper().getDisplayName();
    chatRoomId = getChatRoomIdByUserNmae(widget.username, myUserName!);
    setState(() {});
  }

  onTheLoad() async {
    await getTheSharedpref();
    await getAndSetMessage();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    onTheLoad();
  }

  getChatRoomIdByUserNmae(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "${b}_$a";
    } else {
      return "${a}_$b";
    }
  }

  Widget chatMessageTitle(String message, bool sendByMe) {
    return Row(
      mainAxisAlignment:
          sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  bottomRight:
                      sendByMe ? Radius.circular(0) : Radius.circular(24),
                  topRight: Radius.circular(24),
                  bottomLeft:
                      sendByMe ? Radius.circular(24) : Radius.circular(0)),
              color: sendByMe
                  ? Color.fromARGB(255, 234, 236, 240)
                  : Color.fromARGB(255, 211, 228, 243),
            ),
            child: Text(
              message,
              style: TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget chatMessage() {
    return StreamBuilder(
      stream: messageStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                padding: EdgeInsets.only(bottom: 90, top: 130),
                itemCount: snapshot.data.docs.length,
                reverse: true,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return chatMessageTitle(
                      ds["message"], myUserName == ds["sendBy"]);
                })
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }

  addMessage(bool sendClick) {
    if (messageController.text != "") {
      String message = messageController.text;
      messageController.text = "";

      DateTime now = DateTime.now();
      String fromattedDate = DateFormat('h:mma').format(now);

      Map<String, dynamic> messageInfoMap = {
        "message": message,
        "sendBy": myUserName,
        "ts": fromattedDate,
        "time": FieldValue.serverTimestamp(),
        "imgUrl": myProfilePic,
      };
      messageId ??= randomAlphaNumeric(10);

      DatabaseMethods()
          .addMessage(chatRoomId!, messageId!, messageInfoMap)
          .then((value) {
        Map<String, dynamic> lastMessageInfoMap = {
          "lastMessage": message,
          "lastMessageSendTime": fromattedDate,
          "time": FieldValue.serverTimestamp(),
          "lastMessageSendBy": myUserName,
        };
        DatabaseMethods()
            .updateLastMessageSend(chatRoomId!, lastMessageInfoMap);
        if (sendClick) {
          messageId = null;
        }
      });
    }
  }

  getAndSetMessage() async {
    messageStream = await DatabaseMethods().getChatRoomMessage(chatRoomId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 112, 68, 148),
      body: Container(
        margin: EdgeInsets.only(
          top: 60.0,
          // left: 20.0,
          // right: 2.0,
        ),
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(
                top: 50,
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.12,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: chatMessage(),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 40.0,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return HomePage();
                          },
                        ),
                      );
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Color.fromARGB(255, 243, 144, 177),
                    ),
                  ),
                  SizedBox(
                    width: 100.0,
                  ),
                  Text(
                    widget.name,
                    style: TextStyle(
                      color: Color.fromARGB(255, 247, 114, 158),
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              margin: EdgeInsets.only(
                left: 20,
                right: 20.0,
                bottom: 10,
              ),
              alignment: Alignment.bottomCenter,
              child: Material(
                borderRadius: BorderRadius.circular(20),
                elevation: 5.0,
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Container(
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Type a message",
                          suffixIcon: GestureDetector(
                            onTap: () {
                              addMessage(true);
                            },
                            child: Icon(
                              Icons.send,
                            ),
                          )),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

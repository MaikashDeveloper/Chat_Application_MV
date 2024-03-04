// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/rendering.dart';
import 'package:vm_chat_app/pages/chap_page.dart';
import 'package:vm_chat_app/service/dataabase.dart';
import 'package:vm_chat_app/service/shared_pref.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // varabiles there
  getChatRoomIdByUserNmae(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "${b}_$a";
    } else {
      return "${a}_$b";
    }
  }

  bool search = false;
  String? myName, myProfilePic, myUserName, myEmail;
  Stream? chatRoomsStreams;

  getTheSharedpref() async {
    myName = await SharedPreferenceHelper().getDisplayName();
    myProfilePic = await SharedPreferenceHelper().getUsePic();
    myUserName = await SharedPreferenceHelper().getUseName();
    myEmail = await SharedPreferenceHelper().getUseEmail();
    setState(() {});
  }

  onTheLoad() async {
    await getTheSharedpref();
    chatRoomsStreams = await DatabaseMethods().getChatRooms();
    setState(() {});
  }

  Widget ChatRoomList() {
    return StreamBuilder(
        stream: chatRoomsStreams,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: snapshot.data.docs.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.doc.length;
                    return ChatRoomListTitle(
                        lastMessage: ds['lastMessage'],
                        chatRoomId: ds.id,
                        myUsername: myUserName!,
                        time: ds["lastMessageSendTime"]);
                  },
                )
              : Center(
                  child: CircularProgressIndicator(),
                );
        });
  }

  @override
  void initState() {
    super.initState();
    onTheLoad();
  }

  var queryResultSet = [];
  var temSearchStore = [];

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        temSearchStore = [];
      });
    }
    setState(() {
      search = true;
    });
    var capitalizeValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);
    if (queryResultSet.isEmpty && value.length == 1) {
      DatabaseMethods().Search(value).then((QuerySnapshot docs) {
        for (var i = 0; i < docs.docs.length; ++i) {
          queryResultSet.add(docs.docs[i].data());
        }
      });
    } else {
      temSearchStore = [];
      for (var element in queryResultSet) {
        if (element['Name'].startsWith(capitalizeValue)) {
          setState(() {
            temSearchStore.add(element);
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 112, 68, 148),
      body: SingleChildScrollView(
        child: SizedBox(
          // margin: EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 20.0,
                  top: 35.0,
                  right: 10.0,
                  left: 10.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    search
                        ? Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 30.0),
                              child: TextField(
                                onChanged: (value) {
                                  initiateSearch(value.toUpperCase());
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '  Search user',
                                  hintStyle: TextStyle(
                                    color: Color.fromARGB(251, 196, 153, 209),
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Text(
                            "ChatUp",
                            style: TextStyle(
                              color: Color.fromARGB(251, 196, 153, 209),
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (search) {
                            search = false;
                          } else {
                            search = true;
                          }
                        });
                      },
                      child: Container(
                        padding:
                            search ? EdgeInsets.all(20) : EdgeInsets.all(6),
                        decoration: search
                            ? BoxDecoration(
                                color: Color.fromARGB(255, 58, 33, 68),
                                borderRadius: BorderRadius.circular(20),
                              )
                            : BoxDecoration(
                                color: Color(0xFF3a2144),
                                borderRadius: BorderRadius.circular(20),
                              ),
                        child: search
                            ? Icon(
                                Icons.close,
                                color: Color.fromARGB(249, 156, 114, 214),
                                size: 30,
                              )
                            : Icon(
                                Icons.search,
                                color: Color.fromARGB(251, 196, 153, 209),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: 20.0,
                ),
                height: search
                    ? MediaQuery.of(context).size.height / 1.13
                    : MediaQuery.of(context).size.height / 1.12,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    search
                        ? ListView(
                            padding: EdgeInsets.only(
                              left: 110,
                              right: 10,
                            ),
                            primary: false,
                            shrinkWrap: true,
                            children: temSearchStore.map((element) {
                              return buildResultCard(element);
                            }).toList())
                        : ChatRoomList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildResultCard(data) {
    return GestureDetector(
      onTap: () async {
        search = false;
        setState(
          () {},
        );
        var chatRoomId = getChatRoomIdByUserNmae(myUserName!, data["username"]);
        Map<String, dynamic> chatRoomInfoMap = {
          "user": [
            myUserName,
            data["username"],
          ]
        };
        await DatabaseMethods().creatChatRoom(chatRoomId, chatRoomInfoMap);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: ((context) {
              return ChatPage(
                name: data["Name"],
                profileurl: data["Photo"],
                username: data["username"],
              );
            } // ithu context end
                ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: Image.network(
                    data["Photo"],
                    height: 60,
                    width: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data["Name"],
                      style: TextStyle(
                        color: Colors.black45,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      data['username'],
                      style: TextStyle(
                        color: Colors.black45,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChatRoomListTitle extends StatefulWidget {
  final String lastMessage, chatRoomId, myUsername, time;
  const ChatRoomListTitle(
      {super.key,
      required this.lastMessage,
      required this.chatRoomId,
      required this.myUsername,
      required this.time});

  @override
  State<ChatRoomListTitle> createState() => _ChatRoomListTitleState();
}

class _ChatRoomListTitleState extends State<ChatRoomListTitle> {
  String profilePicUrl = "", name = "", username = "", id = "";
  getThisUseerInfo() async {
    username =
        widget.chatRoomId.replaceAll("_", "").replaceAll(widget.myUsername, "");
    QuerySnapshot querySnapshot =
        await DatabaseMethods().getUserInfo(username.toUpperCase());
    name = "${querySnapshot.docs[0]["Name"]}";
    profilePicUrl = "${querySnapshot.docs[0]['Photo']}";
    id = "${querySnapshot.docs[0]["id"]}";
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          profilePicUrl == ""
              ? CircularProgressIndicator()
              : ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: Image.network(
                    profilePicUrl,
                    height: 70,
                    width: 70,
                    fit: BoxFit.cover,
                  ),
                ),
          SizedBox(
            width: 20.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10.0,
              ),
              Text(
                username,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                widget.lastMessage,
                style: TextStyle(
                  color: Colors.black45,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Spacer(),
          Text(
            widget.time,
            style: TextStyle(
              color: Colors.black45,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 40.0,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.arrow_back_ios,
                    color: Color.fromARGB(255, 243, 144, 177),
                  ),
                  SizedBox(
                    width: 120.0,
                  ),
                  Text(
                    "Spider Man",
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
              padding: EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                top: 50.0,
                bottom: 40.0,
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.15,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 2,
                    ),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 226, 224, 224),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Hello Spidey. I am Maikash",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width / 2,
                    ),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 247, 226, 248),
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(10),
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Hello Maikash. What about you",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Spacer(),
                  Material(
                    borderRadius: BorderRadius.circular(20),
                    elevation: 5.0,
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Type a message",
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.purple[400],
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: Icon(
                                Icons.send,
                                color: const Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

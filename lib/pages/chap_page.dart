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
          left: 20.0,
          right: 20.0,
        ),
        child: Stack(
          children: [
            Row(
              children: [
                Icon(
                  Icons.arrow_back_ios,
                  color: Color.fromARGB(255, 243, 144, 177),
                ),
                SizedBox(
                  width: 100.0,
                ),
                Text(
                  "Spider Man",
                  style: TextStyle(
                    color: Color.fromARGB(255, 243, 144, 177),
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.15,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

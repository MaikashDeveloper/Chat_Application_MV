import 'package:flutter/material.dart';
import 'package:vm_chat_app/pages/chap_page.dart';
import 'package:vm_chat_app/pages/home_page.dart';
import 'package:vm_chat_app/pages/sigin.dart';
//import 'package:vm_chat_app/pages/sigin.dart';
import 'package:vm_chat_app/pages/signup.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ChatPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List pages = [
    SignIn(),
    SignUp(),
    HomePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_counter],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Sign',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Sign',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Sign',
          ),
        ],
        onTap: (value) {
          setState(() {
            _counter = value;
          });
        },
      ),
    );
  }
}

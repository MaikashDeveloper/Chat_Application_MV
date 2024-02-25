import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vm_chat_app/pages/signup.dart';

class ForgoyPassword extends StatefulWidget {
  const ForgoyPassword({super.key});

  @override
  State<ForgoyPassword> createState() => _ForgoyPasswordState();
}

class _ForgoyPasswordState extends State<ForgoyPassword> {
  final _formkey = GlobalKey<FormState>();
  String email = "";
  TextEditingController usermailController = TextEditingController();

  resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text("Password Reset Email has been sent"),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("No User Found For the Email"),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 4.0,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF7f30fe),
                      // Color.fromARGB(15, 239, 4, 243),
                      Colors.deepPurple,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.vertical(
                      bottom: Radius.elliptical(
                          MediaQuery.of(context).size.width, 105.0))),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 74),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      "Password Recovery",
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      "Enter your mail",
                      style: TextStyle(
                        color: Color.fromARGB(255, 204, 203, 203),
                        fontSize: 25.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                    child: Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 30.0, horizontal: 20.0),
                        height: MediaQuery.of(context).size.height / 3,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Form(
                          key: _formkey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Email",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 10.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1.0, color: Colors.black38),
                                ),
                                child: TextFormField(
                                  controller: usermailController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please Enter E-mail";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.email_outlined,
                                        color: Color(0xFF7f30fe)),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 70.0,
                              ),
                              Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_formkey.currentState!.validate()) {
                                      setState(() {
                                        email = usermailController.text;
                                      });
                                      resetPassword();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Color.fromARGB(255, 113, 28, 250),
                                  ),
                                  child: Text(
                                    'Send Email',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => SignUp())));
                        },
                        child: Text(
                          "Sign Up Now!",
                          style: TextStyle(
                            color: Color.fromARGB(255, 98, 0, 255),
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

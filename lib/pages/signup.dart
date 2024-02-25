import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:vm_chat_app/pages/home_page.dart';
import 'package:vm_chat_app/service/dataabase.dart';
import 'package:vm_chat_app/service/shared_pref.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String email = "", password = "", name = "", confirmPassword = "";
  TextEditingController mailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController confirmPasswordcontroller = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  registration() async {
    if (password == confirmPassword) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        String Id = randomAlphaNumeric(10);

        Map<String, dynamic> userInfoMap = {
          "Name": namecontroller.text,
          "E-mail": mailcontroller.text,
          "username": mailcontroller.text.replaceAll("@gmail.com", " "),
          "Photo": "https://m.media-amazon.com/images/I/41jLBhDISxL.jpg",
          "id": Id,
          // "Password": passwordcontroller.text,
          // "Confirm Password": confirmPasswordcontroller.text,
        };

        await DatabaseMethods().addUserDetails(userInfoMap, Id);
        await SharedPreferenceHelper().saveUserId(Id);
        await SharedPreferenceHelper().saveUserDisplayName(namecontroller.text);
        await SharedPreferenceHelper().saveUserEmail(mailcontroller.text);
        await SharedPreferenceHelper().saveUserDisplayName(namecontroller.text);
        await SharedPreferenceHelper().saveUserPic(
          "https://m.media-amazon.com/images/I/41jLBhDISxL.jpg",
        );
        await SharedPreferenceHelper().saveUserName(
          mailcontroller.text.replaceAll("@gmail.com", " "),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Registered Successfully"),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Password is to weak"),
            ),
          );
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Already account exit"),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        // width: MediaQuery.of(context).size.width,
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
                      "SignUp",
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      "Create a new Account",
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
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
                        height: MediaQuery.of(context).size.height / 1.6,
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
                                "Name",
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
                                  controller: namecontroller,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'please enter name';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.person_outline,
                                        color: Color(0xFF7f30fe)),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
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
                                  controller: mailcontroller,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'please enter email';
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
                                height: 20.0,
                              ),
                              Text(
                                "Password",
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
                                  controller: passwordcontroller,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'please enter password';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.key,
                                      color: Color(0xFF7f30fe),
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 11.0,
                              ),
                              Text(
                                "Confirm Password",
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
                                  controller: confirmPasswordcontroller,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'please enter confirm password';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.key,
                                      color: Color(0xFF7f30fe),
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 60.0,
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
                                  Text(
                                    "Sign Up Now!",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 98, 0, 255),
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_formkey.currentState!.validate()) {
                        setState(() {
                          email = mailcontroller.text;
                          name = namecontroller.text;
                          password = passwordcontroller.text;
                          confirmPassword = confirmPasswordcontroller.text;
                        });
                      }
                      registration();
                    },
                    child: Center(
                      child: SizedBox(
                        width: 150,
                        child: Material(
                          elevation: 5.0,
                          borderRadius: BorderRadius.circular(10),
                          child: Center(
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 98, 0, 255),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  "SignUp",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
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

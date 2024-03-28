import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:onlineshop/common_tools/common_tools.dart';
import 'package:onlineshop/common_tools/widget/button.dart';
import 'package:onlineshop/common_tools/widget/text_field.dart';
import 'package:onlineshop/main.dart';

import 'MyApp.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class SignupActivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginBtn = ElevatedButton(
      child: Center(
        child: GestureDetector(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SignIn(),
              )),
          child: Text(
            'Already have an account?\nSign in',
            style: TextStyle(color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      onPressed: () {},
    );

    WidgetsFlutterBinding.ensureInitialized();
    Firebase.initializeApp();
    return Content();
  }
}

class Content extends StatefulWidget {
  @override
  _ContentState createState() => _ContentState();
}

class _ContentState extends State<Content> {
  @override
  Widget build(BuildContext context) {
    return SignUpPage();
  }
}

class SignUpPage extends StatelessWidget {
  TextEditingController mail = new TextEditingController(),
      pass = new TextEditingController(),
      pass2 = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: -90,
            right: -70,
            left: -113,
            child: Image.asset('assets/images/ellipse_top.png'),
          ),
          Positioned(
            top: -25,
            right: 0,
            child: Image.asset(
              'assets/images/crop_circle_top.png',
              height: 130,
              width: 130,
              color: Color(0x330E3305).withOpacity(0.2),
            ),
          ),
          Positioned(
            top: 20,
            left: MediaQuery.of(context).size.width / 6,
            child: Image.asset(
              'assets/images/doel.png',
              height: 100,
              color: Color(0x330E3305).withOpacity(0.07),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 10,
            left: MediaQuery.of(context).size.width / 3,
            child: const Text(
              "REGISTER",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          Positioned(
            bottom: 0,
            right: -13,
            child: Image.asset(
              'assets/images/crop_circle_bottom.png',
              height: 100,
              width: 100,
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 0, left: 20, right: 20),
            child: ListView(
              children: [
                Space(150),
                myRecTextField('Mail Address', mail, 0.8),
                Space(10),
                myPassTextField('Password', pass, 0.8),
                Space(10),
                myPassTextField('Password again', pass2, 0.8),
                Space(10),

                myRactanButton(context, "Sign Up", () {
                  if (pass.text != pass2.text || pass2.text.length < 8) {
                    Fluttertoast.showToast(
                        msg: "Please use 8 length of password!");
                    return;
                  }
                  _register(context);
                }, 0.9, Colors.deepOrange),
                // loginBtn,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _register(BuildContext context) async {
    final User user = (await _auth.createUserWithEmailAndPassword(
      email: mail.text,
      password: pass.text,
    ))
        .user!;
    if (user != null) {
      Fluttertoast.showToast(msg: "Success");
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SignIn(),
          ));
    } else {
      Fluttertoast.showToast(msg: "Failed");
    }
  }
}
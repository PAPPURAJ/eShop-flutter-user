import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onlineshop/product_list.dart';
import 'package:onlineshop/common_tools/common_tools.dart';
import 'package:onlineshop/common_tools/widget/button.dart';
import 'package:onlineshop/common_tools/widget/button_widget.dart';
import 'package:onlineshop/common_tools/widget/text_field.dart';

import 'SignupActivity.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
      apiKey: "AIzaSyCWXIHil2ZSmIY2Mf9k8R-T-ICttjzSPfI",
      authDomain: "eshop-aaf57.firebaseapp.com",
      databaseURL: "https://eshop-aaf57-default-rtdb.firebaseio.com",
      projectId: "eshop-aaf57",
      storageBucket: "eshop-aaf57.appspot.com",
      messagingSenderId: "178172248344",
      appId: "1:178172248344:web:2e97a3f9dc2b8151da5e6d",
      measurementId: "G-EY32CEG0ES"
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: _firebaseAuth.currentUser != null ? const ProductMain() : SignIn(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SignIn extends StatelessWidget {
  TextEditingController? mail, password;

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    Firebase.initializeApp();
    mail = TextEditingController();
    password = TextEditingController();

    final forgotLabel = ElevatedButton(
      child: GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SignupActivity(),
            )),
        child: const Text(
          'Don\'t have an Account?',
          style: TextStyle(color: Colors.black54),
        ),
      ),
      onPressed: () {},
    );
    TextEditingController emailCont = TextEditingController();
    return Scaffold(



      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: -20,
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
              color: const Color(0x330E3305).withOpacity(0.2),
            ),
          ),
          Positioned(
            top: 20,
            left: MediaQuery.of(context).size.width / 6,
            child: Image.asset(
              'assets/images/doel.png',
              height: 170,
              color: const Color(0x330E3305).withOpacity(0.07),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 6,
            left: MediaQuery.of(context).size.width / 3,
            child: const Text(
              "SIGN IN",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 30,
            child: Image.asset(
              'assets/images/doel.png',
              height: 50,
              width: 50,
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
            padding: EdgeInsets.only(top: 0, left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height / 5),
                myRecTextField('Mail Address', mail!, 0.8),
                SizedBox(height: 20.0),
                myPassTextField('Password', password!, 0.8),
                SizedBox(height: 24.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        // Checkbox(
                        //   value: true,
                        //   activeColor: Colors.deepOrange,
                        //   onChanged: (value) {},
                        // ),
                        // Text("Remember me")
                      ],
                    ),
                    GestureDetector(
                      child: const Text(
                        "Forget Password?",
                      ),
                      onTap: () async {


                        showDialog(
                            context: context,
                            builder: (context) => Dialog(
                                  child: Container(
                                    child: ListView(
                                      shrinkWrap: true,
                                      children: [
                                        Space(40),
                                        const SizedBox(
                                          height: 70,
                                          width: 70,
                                          child: Image(
                                              image: AssetImage(
                                                  'assets/images/edit.png')),
                                        ),
                                        Space(40),
                                        getTextField("Email",
                                            'example@gmail.com', emailCont),
                                        Space(20),
                                        ButtonWidget(
                                          text: 'Reset',
                                          icon: Icons.cloud_upload_outlined,
                                          onClicked: () async {
                                            await FirebaseAuth.instance
                                                .sendPasswordResetEmail(
                                                    email: emailCont.text)
                                                .whenComplete(() {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "Reset link sent! Please check your spam");
                                              Navigator.pop(context);
                                            });
                                          },
                                        ),
                                        Space(20),
                                      ],
                                    ),
                                  ),
                                ));
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                myButton(context, "LOG IN", () {
                  _signInWithEmailAndPassword(context);
                }, 0.9),
                forgotLabel
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _signInWithEmailAndPassword(BuildContext context) async {
    try {
      final User? user = (await _auth.signInWithEmailAndPassword(
        email: mail!.text,
        password: password!.text,
      ))
          .user;

      Fluttertoast.showToast(msg: "Success");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ProductMain()));
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed");
    }
  }
}
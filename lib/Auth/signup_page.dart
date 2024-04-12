// ignore: unused_import
// ignore_for_file: unnecessary_new, prefer_is_empty, avoid_print, use_build_context_synchronously, avoid_unnecessary_containers

// ignore: unused_import
import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:bhashini/Auth/constants.dart';
import 'package:bhashini/Auth/otp_verify.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  static String verifyid = "";
  static String phone = "";

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final myController = TextEditingController();

  bool validateMobile(String value) {
    String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return false;
    } else if (!regExp.hasMatch(value)) {
      return false;
    }
    return true;
  }

  setuserdata() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("phone", SignupPage.phone);
    SignupPage.phone = '+91${myController.text}';
    print(myController.text);
    return;
  }

  sendotp() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91${myController.text}',
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) async {
        SignupPage.verifyid = verificationId;
        await Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const otp_verify()));
        Navigator.pop(context);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: white,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 400,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/background.png'),
                          fit: BoxFit.fill)),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: getUnitWidth(context) * 8,
                        width: getUnitWidth(context) * 20,
                        height: getUnitHeight(context) * 50,
                        child: FadeInUp(
                            duration: const Duration(seconds: 1),
                            child: Container(
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image:
                                          AssetImage('assets/images/bag.png'))),
                            )),
                      ),
                      Positioned(
                        left: getUnitWidth(context) * 30,
                        width: getUnitWidth(context) * 20,
                        height: getUnitHeight(context) * 25,
                        child: FadeInUp(
                            duration: const Duration(milliseconds: 1200),
                            child: Container(
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/cart.png'))),
                            )),
                      ),
                      Positioned(
                        right: 40,
                        top: 40,
                        width: 80,
                        height: 150,
                        child: FadeInUp(
                            duration: const Duration(milliseconds: 1300),
                            child: Container(
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/clock.png'))),
                            )),
                      ),
                      Positioned(
                        child: FadeInUp(
                            duration: const Duration(milliseconds: 1600),
                            child: Container(
                              margin: EdgeInsets.only(
                                  top: getUnitHeight(context) * 2),
                              child: const Center(
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    children: <Widget>[
                      FadeInUp(
                          duration: const Duration(milliseconds: 1800),
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: greenColor),
                                boxShadow: [
                                  BoxShadow(
                                      color: gray,
                                      blurRadius: 20.0,
                                      offset: const Offset(0, 10))
                                ]),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  // decoration: BoxDecoration(
                                  //     border: Border(
                                  //         bottom:
                                  //             BorderSide(color: greenColor))),
                                  child: TextField(
                                    controller: myController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      labelText: 'Phone Number',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                      const SizedBox(
                        height: 30,
                      ),
                      FadeInUp(
                          duration: const Duration(milliseconds: 1900),
                          child: SizedBox(
                            width: getUnitWidth(context) * 85,
                            child: MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              elevation: 2,
                              height: getUnitHeight(context) * 6,
                              color: greenColor,
                              onPressed: () async {
                                if (!validateMobile(myController.text)) {
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      // title: const Text('AlertDialog Title'),
                                      content: const Text(
                                          "Enter a valid phone number"),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'OK'),
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  await sendotp();
                                  await setuserdata();
                                }
                              },
                              minWidth: getUnitWidth(context) * 1,
                              child: Text(
                                "Login",
                                style: TextStyle(color: white),
                              ),
                            ),
                          )),
                      const SizedBox(
                        height: 70,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

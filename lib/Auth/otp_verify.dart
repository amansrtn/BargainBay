// ignore_for_file: avoid_print, avoid_unnecessary_containers

import 'package:animate_do/animate_do.dart';
import 'package:bhashini/Auth/buyer_formpage.dart';
import 'package:bhashini/Auth/constants.dart';
import 'package:bhashini/Auth/signup_page.dart';
import 'package:bhashini/Auth/vendor_formpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class otp_verify extends StatefulWidget {
  const otp_verify({super.key});

  @override
  State<otp_verify> createState() => _otp_verifyState();
}

class _otp_verifyState extends State<otp_verify> {
  final myController = TextEditingController();
  bool usertype = true; //true->vendor: false->customer
  String accesskey = "";
  String refreshkey = "";
  String username = SignupPage.phone;

  setusertype() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('usertype', usertype);
    print(usertype);
    return;
  }

  savetoken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accesskey', accesskey);
    await prefs.setString('refreshkey', refreshkey);
    await prefs.setString('username', username);
    print(usertype);
    return;
  }

  verifyuser() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: SignupPage.verifyid, smsCode: myController.text);
      await auth.signInWithCredential(credential);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        child: Scaffold(
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
                                          image: AssetImage(
                                              'assets/images/bag.png'))),
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
                                  child: Center(
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: getUnitHeight(context) * 22,
                                        ),
                                        const Text(
                                          "OTP",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 40,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Text(
                                          "Verification",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 40,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
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
                                          labelText: 'Enter OTP',
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
                              child: Column(
                                children: [
                                  Container(
                                    width: getUnitWidth(context) * 85,
                                    child: MaterialButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      elevation: 2,
                                      height: getUnitHeight(context) * 6,
                                      color: greenColor,
                                      onPressed: () async {
                                        if (await verifyuser()) {
                                          showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                              // title: const Text('AlertDialog Title'),
                                              content: const Text(
                                                  "New User Registration"),
                                              actions: <Widget>[
                                                MaterialButton(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5)),
                                                    elevation: 2,
                                                    height:
                                                        getUnitHeight(context) *
                                                            4,
                                                    color: white,
                                                    onPressed: () async {
                                                      usertype = true;
                                                      await setusertype();
                                                      await Navigator.of(
                                                              context)
                                                          .push(MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const form_page()));
                                                      Navigator.pop(context);
                                                    },
                                                    child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 20),
                                                        child: const Text(
                                                            "Vendor Registration"))),
                                                MaterialButton(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5)),
                                                    elevation: 2,
                                                    height:
                                                        getUnitHeight(context) *
                                                            4,
                                                    color: white,
                                                    onPressed: () async {
                                                      usertype = false;
                                                      await setusertype();
                                                      await Navigator.of(
                                                              context)
                                                          .push(MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const userform()));
                                                      Navigator.pop(context);
                                                    },
                                                    child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        child: const Text(
                                                            "Customer Registration")))
                                              ],
                                            ),
                                          );
                                        } else {
                                          showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                              // title: const Text('AlertDialog Title'),
                                              content: const Text(
                                                  "Invalid OTP/OTP Expired"),
                                              actions: <Widget>[
                                                MaterialButton(
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                    elevation: 2,
                                                    height:
                                                        getUnitHeight(context) *
                                                            4,
                                                    child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        child: const Text(
                                                          "Go back to login page",
                                                          textAlign:
                                                              TextAlign.justify,
                                                        )),
                                                    color: white,
                                                    onPressed: () async {
                                                      usertype = true;
                                                      await setusertype();
                                                      await Navigator.of(
                                                              context)
                                                          .push(MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const SignupPage()));
                                                      Navigator.pop(context);
                                                    }),
                                              ],
                                            ),
                                          );
                                        }
                                      },
                                      minWidth: getUnitWidth(context) * 1,
                                      child: Text(
                                        "Verify",
                                        style: TextStyle(color: white),
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const SignupPage()));
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Edit phone number",
                                          style: TextStyle(
                                              color: gray, fontSize: 12),
                                        ),
                                      )),
                                ],
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
            )));
  }
}

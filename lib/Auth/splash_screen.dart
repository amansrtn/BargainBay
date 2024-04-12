// ignore_for_file: camel_case_types, use_build_context_synchronously

import 'dart:async';

import 'package:bhashini/Buyer/Pages/entrypage.dart';
import 'package:bhashini/Seller/Pages/entrypage_seller.dart';
import 'package:bhashini/Auth/constants.dart';
import 'package:bhashini/Auth/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class splash_screen extends StatefulWidget {
  const splash_screen({super.key});

  @override
  State<splash_screen> createState() => _splash_screenState();
}

class _splash_screenState extends State<splash_screen> {
  void isLoggedIn() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool? isSeller = pref.getBool("usertype");
    if (pref.getString("accessToken") != null && isSeller != null) {
      if (isSeller) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => EntryPageSeller(
                      selectedPos: 0,
                    )));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const EntryPage()));
      }
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const SignupPage()));
    }
  }

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () => isLoggedIn());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.fromLTRB(
              getUnitWidth(context) * 3, 0, getUnitWidth(context) * 3, 0),
          child: const Image(
            image: AssetImage("assets/images/cnd-nobg.png"),
            alignment: Alignment.center,
          ),
        ));
  }
}

// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'package:bhashini/Buyer/Classes/text_class.dart';
import 'package:bhashini/Buyer/Pages/categorypage.dart';
import 'package:bhashini/Buyer/Pages/coversation.dart';
import 'package:bhashini/Buyer/Pages/homepage.dart';
import 'package:bhashini/Buyer/Pages/profilepage.dart';
import 'package:bhashini/CallingScreens/caller_screen.dart';
import 'package:bhashini/CallingScreens/incomingcall.dart';
import 'package:bhashini/chat_message/getlocal_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:circular_bottom_navigation/tab_item.dart';

class EntryPage extends StatefulWidget {
  const EntryPage({
    Key? key,
    this.title,
  }) : super(key: key);
  final String? title;

  @override
  _EntryPageState createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  List<Widget> pageselect = [
    const HomePage(),
    Categories(),
    const ConversationPage(),
    const ProfilePage()
  ];
  TextClass textclass = TextClass();
  ColorClass colorclass = ColorClass();
  List<TabItem> tabItems = List.of([
    TabItem(Icons.home, "Home", const Color(0xff229f3d),
        labelStyle: const TextStyle(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontFamily: "Poppins")),
    TabItem(Icons.category, "Categories", const Color(0xff229f3d),
        labelStyle: const TextStyle(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontFamily: "Poppins")),
    TabItem(Icons.message_rounded, "Conversation", const Color(0xff229f3d),
        labelStyle: const TextStyle(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontFamily: "Poppins")),
    TabItem(Icons.person, "Profile", const Color(0xff229f3d),
        labelStyle: const TextStyle(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontFamily: "Poppins"))
  ]);

  late CircularBottomNavigationController _navigationController;
  int selectedPos = 0;

  @override
  void initState() {
    super.initState();
    checkuser();
    _navigationController = CircularBottomNavigationController(selectedPos);
  }

  String? useremail;
  void checkuser() async {
    bool? usertype = await type();

    if (usertype == false) {
      useremail = await buyergetuseremail();
    } else {
      useremail = await sellergetuseremail();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("call")
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (cx, chatsnap) {
            if (chatsnap.connectionState == ConnectionState.waiting) {
              return Scaffold(
                  body: SafeArea(child: pageselect[selectedPos]),
                  bottomNavigationBar: bottomNav());
            }
            if (!chatsnap.hasData || chatsnap.data!.docs.isEmpty) {
              return Scaffold(
                body: SafeArea(child: pageselect[selectedPos]),
                bottomNavigationBar: bottomNav(),
              );
            }
            if (chatsnap.hasError) {
              return Scaffold(
                  body: SafeArea(child: pageselect[selectedPos]),
                  bottomNavigationBar: bottomNav());
            }
            final loadedmsg = chatsnap.data!.docs;
            Map<String,dynamic> chatmessage = loadedmsg[0].data();
            print("dniiiiiiiiiiiii");
            print(chatmessage["reciver_email"]);
            print(useremail);
            if (useremail != chatmessage["reciver_email"]) {
              return Scaffold(
                  body: SafeArea(child: pageselect[selectedPos]),
                  bottomNavigationBar: bottomNav());
            } else {
              return incomingcall(
                chatmsg: chatmessage,
              );
            }
          }),
    );
  }

  Widget bottomNav() {
    return CircularBottomNavigation(
      tabItems,
      controller: _navigationController,
      selectedPos: selectedPos,
      barBackgroundColor: const Color(0XFFEDF8EF),
      animationDuration: const Duration(milliseconds: 500),
      selectedCallback: (int? sel) {
        setState(() {
          selectedPos = sel ?? 0;
          print(_navigationController.value);
        });
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _navigationController.dispose();
  }
}

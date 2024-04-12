// ignore_for_file: file_names, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, unused_import, use_build_context_synchronously

import 'package:bhashini/Buyer/Classes/text_class.dart';
import 'package:bhashini/Buyer/Serializers/product_serializer.dart';
import 'package:bhashini/CallingScreens/caller_screen.dart';
import 'package:bhashini/chat_message/getlocal_data.dart';
import 'package:bhashini/chat_message/privatesendmessage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'PrivateChatsShow.dart';

class PrivateChatScreen extends StatefulWidget {
  const PrivateChatScreen({super.key, this.prod});
  final Product? prod;
  // final QueryDocumentSnapshot<Object?> senderdata;
  @override
  State<PrivateChatScreen> createState() => _PrivateChatScreenState();
}

final authenticateduser = FirebaseAuth.instance.currentUser;
TextClass textclass = TextClass();
ColorClass colorclass = ColorClass();

class _PrivateChatScreenState extends State<PrivateChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorclass.palewhite,
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: IconButton(
                onPressed: () async {
                  FirebaseFirestore.instance.collection("call").add({
                    "createdAt": Timestamp.now(),
                    "sender_email": await buyergetuseremail(),
                    "reciver_email": widget.prod?.seller_email,
                    "reciver_lang": widget.prod?.seller_lang,
                    "reciver_gender": widget.prod?.seller_gender,
                    "sender_lang": await buyergetlang(),
                    "sender_gender": await buyergetusertype(),
                    "picked": "false"
                  });
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => callerscreen(
                                prod: widget.prod,
                              )));
                },
                icon: Icon(
                  Icons.call,
                  size: 26,
                  color: colorclass.black,
                )),
          )
        ],
        backgroundColor: colorclass.palewhite,
        // title: authenticateduser!.uid ==
        //         (widget.senderdata.data() as Map<String, dynamic>)["user1"]
        //             .toString()

        //     ? Text(
        //         (widget.senderdata.data() as Map<String, dynamic>)["user2name"]
        //             .toString(),
        //             style: textclass.heading1,
        //       )
        //     : Text(
        //         (widget.senderdata.data() as Map<String, dynamic>)["user1name"]
        //             .toString(),
        //             style: textclass.heading1,
        //       ),
        title: Text(
          "Chat",
          style: textclass.title,
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
      ),
      body: Column(
        children: [
          Expanded(
              child: PriChats(
            prod: widget.prod,
          )),
          // PrivateSendMessage(
          //   prod: widget.prod,
          // )
        ],
      ),
    );
  }
}

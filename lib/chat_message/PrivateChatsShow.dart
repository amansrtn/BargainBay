// ignore_for_file: file_names, prefer_typing_uninitialized_variables, unnecessary_import, unused_import

import 'package:bhashini/Buyer/Classes/text_class.dart';
import 'package:bhashini/Buyer/Serializers/product_serializer.dart';
import 'package:bhashini/chat_message/getlocal_data.dart';
import 'package:bhashini/chat_message/privatechatscreen.dart';
import 'package:bhashini/chat_message/privatesendmessage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'PrivateMessagebubble.dart';

class PriChats extends StatefulWidget {
  const PriChats({super.key, this.prod});
  final Product? prod;
  // final QueryDocumentSnapshot<Object?> reciverdata;
  @override
  State<PriChats> createState() => _PriChatsState();
}

class _PriChatsState extends State<PriChats> {
  @override
  void initState() {
    checkuser();
    super.initState();
  }

  String? useremail;
  Future<void> deleteCollection(String collectionPath) async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection(collectionPath).get();

    for (final DocumentSnapshot doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  void checkuser() async {
    bool? usertype = await type();

    if (usertype == false) {
      setState(() async {
        useremail = await buyergetuseremail();
      });
    } else {
      setState(() async {
        useremail = await sellergetuseremail();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authenticateduser = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("privatechat")
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (cx, chatsnap) {
          if (chatsnap.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            );
          }
          if (!chatsnap.hasData || chatsnap.data!.docs.isEmpty) {
            return Center(
              child: Text(
                "No Message Found",
                style: textclass.heading1,
              ),
            );
          }
          if (chatsnap.hasError) {
            return Center(
              child: Text(
                "Something Went Wrong",
                style: textclass.heading1,
              ),
            );
          }

          final loadedmsg = chatsnap.data!.docs;
          var chatmessage = loadedmsg[0].data();
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                    padding:
                        const EdgeInsets.only(bottom: 40, left: 13, right: 13),
                    reverse: true,
                    itemCount: loadedmsg.length,
                    itemBuilder: (context, index) {
                      chatmessage = loadedmsg[index].data();
                      final nextchatmessage = index + 1 < loadedmsg.length
                          ? loadedmsg[index + 1].data()
                          : null;
                      final currentchatuserid = chatmessage["user_id"];
                      final nextchatuserid = nextchatmessage != null
                          ? nextchatmessage["user_id"]
                          : null;

                      final nextusersame = currentchatuserid == nextchatuserid;
                      if (loadedmsg.length > 4000) {
                        deleteCollection('privatechat');
                      }
                      if (useremail != chatmessage["reciver_email"] &&
                          useremail != chatmessage["sender_email"]) {
                        return const SizedBox();
                      }
                      if (nextusersame) {
                        return PrivateMessageBubble.next(
                          userid: chatmessage["user_id"],
                          user1email: chatmessage["sender_email"],
                          user2email: chatmessage["reciver_email"],
                          username: chatmessage["sender_name"],
                          message: chatmessage["text"],
                          isMe: authenticateduser!.uid == currentchatuserid,
                        );
                      } else {
                        return PrivateMessageBubble.first(
                            username: chatmessage["sender_name"],
                            user1email: chatmessage["sender_email"],
                            message: chatmessage["text"],
                            userid: chatmessage["user_id"],
                            user2email: chatmessage["reciver_email"],
                            isMe: authenticateduser!.uid == currentchatuserid);
                      }
                    }),
              ),
              PrivateSendMessage(
                prod: widget.prod,
                reciver_email: chatmessage["sender_email"],
                reciver_lang: chatmessage["sender_lang"],
                reciver_gender: chatmessage["sender_gender"],
                reciver_name: chatmessage["sender_name"],
              )
            ],
          );
        });
  }
}

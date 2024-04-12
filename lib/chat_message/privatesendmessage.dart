// ignore_for_file: file_names, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, use_build_context_synchronously, unused_local_variable, unused_import

import "package:bhashini/Buyer/Serializers/product_serializer.dart";
import "package:bhashini/Seller/Classes/text_class.dart";
import "package:bhashini/chat_message/getlocal_data.dart";
import "package:bhashini/chat_message/privatechatscreen.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";

class PrivateSendMessage extends StatefulWidget {
  const PrivateSendMessage(
      {super.key,
      this.prod,
      required this.reciver_email,
      required this.reciver_lang,
      required this.reciver_gender,
      required this.reciver_name});
  final Product? prod;
  final String reciver_email;
  final String reciver_lang;
  final String reciver_gender;
  final String reciver_name;
  // final QueryDocumentSnapshot<Object?> reciverdata;
  @override
  State<PrivateSendMessage> createState() => _PrivateSendMessageState();
}

class _PrivateSendMessageState extends State<PrivateSendMessage> {
  final _messagecontroller = TextEditingController();
  TextClass textclass = TextClass();
  ColorClass colorclass = ColorClass();
  @override
  void dispose() {
    _messagecontroller.dispose();
    super.dispose();
  }

  void Privatesendmessage(String reciver_email, String reciver_lang,
      String reciver_gender, String reciver_name) async {
    final _enteredmessage = _messagecontroller.text;
    
    if (_enteredmessage.trim().isEmpty) {
      return;
    }
    FocusScope.of(context).unfocus();
    _messagecontroller.clear();
    bool? usertype = await type();
    if (usertype == false) {
      FirebaseFirestore.instance.collection("privatechat").add({
        "text": _enteredmessage,
        "createdAt": Timestamp.now(),
        "user_id": FirebaseAuth.instance.currentUser!.uid,
        "sender_email": await buyergetuseremail(),
        "reciver_email": widget.prod?.seller_email,
        "reciver_lang": widget.prod?.seller_lang,
        "reciver_gender": widget.prod?.seller_gender,
        "reciver_name": widget.prod?.sellerFName,
        "sender_name": await buyergetname(),
        "sender_lang": await buyergetlang(),
        "sender_gender": await buyergetusertype()
      });
    } else {
      FirebaseFirestore.instance.collection("privatechat").add({
        "text": _enteredmessage,
        "createdAt": Timestamp.now(),
        "user_id": FirebaseAuth.instance.currentUser!.uid,
        "sender_email": await sellergetuseremail(),
        "reciver_email": widget.reciver_email,
        "reciver_lang": widget.reciver_lang,
        "reciver_gender": widget.reciver_gender,
        "reciver_name": widget.reciver_name,
        "sender_name": await sellergetname(),
        "sender_lang": await sellergetlang(),
        "sender_gender": await sellergetusertype()
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 3, bottom: 14),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              maxLength: 150,
              controller: _messagecontroller,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: InputDecoration(
                label: Text(
                  "Send Message",
                  style: textclass.heading1,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: colorclass.black),
                ),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(),
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
              ),
              style: textclass.body,
              cursorColor: colorclass.grey,
            ),
          ),
          IconButton(
              iconSize: 35,
              color: colorclass.black,
              style: IconButton.styleFrom(
                  padding: const EdgeInsets.only(bottom: 22)),
              onPressed: () {
                //  "reciver_email": widget.prod.seller_email,
                // "reciver_lang": widget.prod.seller_lang,
                // "reciver_gender": widget.prod.seller_gender,
                // "reciver_name": widget.prod.sellerFName,
                Privatesendmessage(widget.reciver_email, widget.reciver_lang,
                    widget.reciver_gender, widget.reciver_name);
              },
              icon: const Icon(Icons.send)),
        ],
      ),
    );
  }
}

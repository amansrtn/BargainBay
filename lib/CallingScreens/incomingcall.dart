// ignore_for_file: body_might_complete_normally_nullable, camel_case_types, unused_local_variable, avoid_print, avoid_function_literals_in_foreach_calls

import 'package:bhashini/Buyer/Classes/text_class.dart';
import 'package:bhashini/Buyer/Pages/entrypage.dart';
import 'package:bhashini/CallingScreens/caller_screen.dart';
import 'package:bhashini/chat_message/getlocal_data.dart';
import 'package:bhashini/Auth/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:slider_button/slider_button.dart';

class incomingcall extends StatefulWidget {
  const incomingcall({super.key, required this.chatmsg});
  final Map<String, dynamic> chatmsg;
  @override
  State<incomingcall> createState() => _incomingcallState();
}

void updateCollectionDocuments() async {
  try {
    checkuser();
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('call');
    QuerySnapshot querySnapshot = await collectionRef.get();
    querySnapshot.docs.forEach((DocumentSnapshot document) async {
      // Extract the data of the document
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;

      if (useremail == data["reciver_email"]) {
        data['picked'] = 'true';
        await document.reference.update(data);
      }
    });
    print('Documents updated successfully.');
  } catch (e) {
    print('Error updating documents: $e');
  }
}

TextClass textclass = TextClass();
ColorClass colorclass = ColorClass();
String? useremail;
void checkuser() async {
  bool? usertype = await type();
  if (usertype == false) {
    useremail = await buyergetuseremail();
  } else {
    useremail = await sellergetuseremail();
  }
}

Future<void> deleteCollection(String collectionPath) async {
  final QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection(collectionPath).get();

  for (final DocumentSnapshot doc in snapshot.docs) {
    await doc.reference.delete();
  }
}

class _incomingcallState extends State<incomingcall> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: getUnitHeight(context) * 19,
          ),
          const Center(
            child: CircleAvatar(
              radius: 100,
              backgroundImage: AssetImage('assets/images/clock.png'),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(bottom: getUnitHeight(context) * 28)),
          SliderButton(
            backgroundColor: const Color.fromARGB(255, 173, 241, 175),
            action: () async {
              ///Do something here
              ///Navigator.pushReplacement(context,
              updateCollectionDocuments();

              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => callerscreen(
                            prod: null,
                            chatmsg: widget.chatmsg,
                          )));
            },
            label: const Text(
              "Slide to Pickup",
              // selectionColor: Colors.green,
              style: TextStyle(
                  color: Color(0xff4a4a4a),
                  fontWeight: FontWeight.w500,
                  fontSize: 17),
            ),
            icon: const Image(
              image: AssetImage("assets/images/call_pickup.png"),
              height: 40,
            ),
          ),
          SizedBox(
            height: getUnitHeight(context) * 4,
          ),
          SliderButton(
            backgroundColor: const Color.fromARGB(255, 173, 241, 175),
            action: () async {
              ///Do something here
              // Navigator.of(context).pop();
              deleteCollection('call');
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const EntryPage()));
            },
            label: const Text(
              "Slide to Cancel",
              // selectionColor: Colors.green,
              style: TextStyle(
                  color: Color(0xff4a4a4a),
                  fontWeight: FontWeight.w500,
                  fontSize: 17),
            ),
            icon: const Image(
              image: AssetImage("assets/images/call_declined.png"),
              height: 40,
            ),
          )
        ],
      ),
    );
  }
}

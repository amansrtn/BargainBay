import 'package:bhashini/Buyer/Classes/text_class.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    TextClass textclass = TextClass();
    ColorClass colorclass = ColorClass();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Aman Kumar Singh",
            style: TextStyle(
                fontSize: 32,
                color: colorclass.grey,
                fontWeight: FontWeight.w600,
                fontFamily: "Poppins"),
          ),
          const SizedBox(
            height: 8,
          ),
          Text("8638332396", style: textclass.heading1),
          const SizedBox(
            height: 8,
          ),
          Text("F-16, Beta 2, Greater Noida, UP, India",
              style: textclass.heading1),
          const SizedBox(
            height: 24,
          ),
          Container(
            decoration: BoxDecoration(
                color: colorclass.palewhite,
                borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              title: Text("Change Your Address", style: textclass.cta),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Container(
            decoration: BoxDecoration(
                color: colorclass.palewhite,
                borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              title: Text("Share the app", style: textclass.cta),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Container(
            decoration: BoxDecoration(
                color: colorclass.palewhite,
                borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              title: Text("About us", style: textclass.cta),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Container(
            decoration: BoxDecoration(
                color: colorclass.palewhite,
                borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              title: Text("Rate us on Play Store", style: textclass.cta),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Container(
            decoration: BoxDecoration(
                color: colorclass.palewhite,
                borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              title: Text("Account Privacy", style: textclass.cta),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Container(
            decoration: BoxDecoration(
                color: colorclass.palewhite,
                borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              title: Text("Notification preferences", style: textclass.cta),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Container(
            decoration: BoxDecoration(
                color: colorclass.palewhite,
                borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              title: Text("Aman Kumar Singh", style: textclass.cta),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Container(
            decoration: BoxDecoration(
                color: colorclass.palewhite,
                borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              title: Text("Log out", style: textclass.cta),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }
}

import 'package:bhashini/Buyer/Classes/text_class.dart';
import 'package:bhashini/Buyer/Widgets/pageselector.dart';
import 'package:flutter/material.dart';

class ConversationPage extends StatelessWidget {
  const ConversationPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextClass textclass = TextClass();
    ColorClass colorclass = ColorClass();
    return Padding(
      padding: const EdgeInsets.only(top: 32.0, left: 8, right: 8),
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: ((context, index) {
          return Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: colorclass.palewhite,
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  trailing: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  leading: CircleAvatar(
                    backgroundImage: AssetImage("assets/${index + 1}.jpeg"),
                  ),
                  title: Text("Aman Kumar Singh", style: textclass.heading1),
                  subtitle: Text(
                    categories[index],
                    style: textclass.body,
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              )
            ],
          );
        }),
      ),
    );
  }
}

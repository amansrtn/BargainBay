import 'package:bhashini/Seller/Classes/text_class.dart';
import 'package:flutter/material.dart';

class GridItem extends StatelessWidget {
  final String heading;
  final String subHeading;
  final IconData icon;

  const GridItem(
      {Key? key,
      required this.heading,
      required this.subHeading,
      required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ColorClass colorClass = ColorClass();
    TextClass textClass = TextClass();
    return Container(
        margin: const EdgeInsets.all(8.0),
        height: MediaQuery.of(context).size.height * 0.15,
        width: MediaQuery.of(context).size.width * 0.35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: colorClass.palewhite,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    heading,
                    style: textClass.heading2,
                  ),
                  Icon(
                    icon,
                    color: colorClass.green,
                  )
                ],
              ),
              Text(
                subHeading,
                style: textClass.title,
              )
            ],
          ),
        ));
  }
}

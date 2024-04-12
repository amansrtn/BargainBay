import 'package:bhashini/Buyer/Pages/entrypage.dart';
import 'package:bhashini/Seller/Pages/entrypage_seller.dart';
import 'package:flutter/material.dart';

class SlectorPage extends StatelessWidget {
  const SlectorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EntryPageSeller(selectedPos: 0)));
                },
                child: Text("Seller")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => EntryPage()));
                },
                child: Text("Buyer")),
          ],
        ),
      ),
    );
  }
}

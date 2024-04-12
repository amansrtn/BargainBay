import 'package:bhashini/Buyer/Serializers/product_serializer.dart';
import 'package:flutter/material.dart';

class ConnectSellerPage extends StatefulWidget {
  const ConnectSellerPage({super.key, required this.prod});
  final Product prod;
  @override
  State<ConnectSellerPage> createState() => _ConnectSellerPageState();
}

class _ConnectSellerPageState extends State<ConnectSellerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Message"),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "All details about product, it's seller and category.",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text("prod.prodId: ${widget.prod.prodId}"),
            Text("prod.prodName: ${widget.prod.prodName}"),
            Text("prod.sellerUName: ${widget.prod.sellerUName}"),
            Text("prod.sellerFName: ${widget.prod.sellerFName}"),
            Text("prod.sellerLName: ${widget.prod.sellerLName}"),
            Text("prod.sellerPhone: ${widget.prod.sellerPhone}"),
            Text("prod.catId: ${widget.prod.catId}"),
            Text("prod.catName: ${widget.prod.catName}"),
            Text("prod.unitPrice: ${widget.prod.unitPrice}"),
          ],
        ),
      ),
    );
  }
}

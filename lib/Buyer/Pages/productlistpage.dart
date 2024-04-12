// ignore_for_file: library_private_types_in_public_api, must_be_immutable, unused_import, non_constant_identifier_names

import 'dart:convert';
import 'dart:io';
import 'package:bhashini/Buyer/Classes/text_class.dart';
import 'package:bhashini/Buyer/Pages/connect_to_seller.dart';
import 'package:bhashini/Buyer/Serializers/product_serializer.dart';
import 'package:bhashini/Global/default_token.dart';
import 'package:bhashini/chat_message/privatechatscreen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductListPage extends StatefulWidget {
  @override
  ProductListPage({Key? key, required this.catId}) : super(key: key);
  String catId;
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  Future<List<Product>> fetchProducts() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? DEFAULT_TOKEN = pref.getString('accessToken');
    final response = await http.post(
      Uri.parse('$API/api/buyer/getprod/'),
      body: {'category_id': widget.catId},
      headers: {'Authorization': 'Bearer $DEFAULT_TOKEN'},
    );
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['result'];

      return data.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  TextClass textClass = TextClass();

  ColorClass colorClass = ColorClass();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
      ),
      body: FutureBuilder<List<Product>>(
        future: fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return const Center(
              child:
                  Text("No product in this category, Try adding new product."),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    tileColor: colorClass.palewhite,
                    leading: Image.network(
                      snapshot.data![index].image,
                      fit: BoxFit.cover,
                    ),
                    title: Text(
                      snapshot.data![index].prodName,
                      style: textClass.heading1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text('ID: ${snapshot.data![index].prodId}\n'
                        'Unit Price: \$${snapshot.data![index].unitPrice}\n'
                        'Seller: ${snapshot.data![index].sellerFName} ${snapshot.data![index].sellerLName}'),
                    trailing: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PrivateChatScreen(
                                prod: snapshot.data![index])));
                      },
                      child: const Text('Contact Seller'),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

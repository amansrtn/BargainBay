// ignore_for_file: must_be_immutable, library_private_types_in_public_api

import 'dart:convert';
import 'dart:io';
import 'package:bhashini/Seller/Classes/text_class.dart';
import 'package:bhashini/Seller/Pages/additem.dart';
import 'package:bhashini/Global/default_token.dart';
import 'package:bhashini/chat_message/privatechatscreen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Product {
  final int id;
  final String name;
  final double unitPrice;
  final int quantityInInventory;
  final String image;

  Product({
    required this.id,
    required this.name,
    required this.unitPrice,
    required this.quantityInInventory,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      unitPrice: double.parse(json['unit_price']),
      quantityInInventory: json['quantity'],
      image: json['img_url'],
    );
  }
}

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
      Uri.parse('$API/api/seller/getprod/'),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: colorClass.green,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => NewProductForm(
                    onSubmit: (String category, String name, double price,
                        int quantity, File? image) {
                      print(name);
                    },
                    catId: widget.catId,
                  )));
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
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
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              const PrivateChatScreen()));
                    },
                    child: ListTile(
                      tileColor: colorClass.palewhite,
                      leading: Image.network(
                        snapshot.data![index].image,
                        fit: BoxFit.cover,
                      ),
                      title: Text(
                        snapshot.data![index].name,
                        style: textClass.heading1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text('ID: ${snapshot.data![index].id}\n'
                          'Unit Price: \$${snapshot.data![index].unitPrice.toStringAsFixed(2)}\n'
                          'Quantity: ${snapshot.data![index].quantityInInventory}'),
                      trailing: ElevatedButton(
                        onPressed: () {
                          // Navigate to edit page or perform edit action
                        },
                        child: const Text('Edit'),
                      ),
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

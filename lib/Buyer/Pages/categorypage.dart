// ignore_for_file: must_be_immutable, non_constant_identifier_names, prefer_final_fields

import 'dart:convert';

import 'package:bhashini/Buyer/Classes/text_class.dart';
import 'package:bhashini/Buyer/Pages/productlistpage.dart';
import 'package:bhashini/Buyer/Serializers/category_serializer.dart';
import 'package:bhashini/Global/default_token.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Categories extends StatefulWidget {
  Categories({super.key});
  bool isSearching = false;

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  Future<List<Category>> _fetchAllCategoriesFromAPI(String contains) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? DEFAULT_TOKEN = pref.getString('accessToken');
    final response = await http.post(
      Uri.parse('$API/api/seller/getallcat/'),
      body: {'contains': contains},
      headers: {'Authorization': 'Bearer $DEFAULT_TOKEN'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['result'];
      return data.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  String contains = "";
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TextClass textclass = TextClass();
    ColorClass colorclass = ColorClass();
    return Scaffold(
        appBar: AppBar(
          title: !widget.isSearching
              ? Text("Categories", style: textclass.subTitle)
              : ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: TextField(
                    controller: _searchController,
                    style: textclass.heading1,
                    onChanged: (value) {
                      setState(() {
                        contains = value;
                      });
                    },
                    decoration: InputDecoration(
                      prefixIcon: IconButton(
                        icon: Icon(
                          Icons.search,
                          color: colorclass.green,
                        ),
                        onPressed: () {},
                      ),
                      hintText: 'Search For Category',
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.window_rounded,
                          color: colorclass.green,
                        ),
                        onPressed: () {},
                      ),
                      border: InputBorder.none,
                      filled: true,
                      fillColor: colorclass.palewhite,
                    ),
                  ),
                ),
          actions: [
            IconButton(
              icon: !widget.isSearching
                  ? const Icon(Icons.search)
                  : const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  widget.isSearching = !widget.isSearching;
                });
              },
            ),
          ],
        ),
        body: FutureBuilder<List<Category>>(
          future: _fetchAllCategoriesFromAPI(contains),
          builder:
              (BuildContext context, AsyncSnapshot<List<Category>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData && snapshot.data!.isEmpty) {
              return const Center(
                child: Text('Nothing to show'),
              );
            } else {
              return GridView.builder(
                scrollDirection: Axis.vertical,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 0.8,
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  var category = snapshot.data![index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ProductListPage(
                                  catId: category.categoryId.toString(),
                                )));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: colorclass.palewhite,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                                bottomLeft: Radius.circular(6),
                                bottomRight: Radius.circular(6),
                              ),
                              child: Image.network(category.imgUrl),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              category.categoryName,
                              style: textclass.heading1,
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ));
  }
}

// ignore_for_file: unnecessary_const, avoid_unnecessary_containers, no_leading_underscores_for_local_identifiers, unused_import, non_constant_identifier_names

import 'dart:convert';

import 'package:bhashini/Buyer/Classes/text_class.dart';
import 'package:bhashini/Buyer/Pages/productlistpage.dart';
import 'package:bhashini/Buyer/Serializers/category_serializer.dart';
import 'package:bhashini/Global/default_token.dart';

import 'package:bhashini/Buyer/Widgets/pageselector.dart';

import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  @override
  Widget build(BuildContext context) {
    TextClass textclass = TextClass();
    ColorClass colorclass = ColorClass();
    TextEditingController _searchController = TextEditingController();
    return Stack(
      children: [
        Positioned(
            top: MediaQuery.of(context).size.height / 14,
            left: MediaQuery.of(context).size.width / 22,
            child: Text("Aman Kumar Singh", style: textclass.heading1)),
        Positioned(
          top: MediaQuery.of(context).size.height / 50,
          left: MediaQuery.of(context).size.width / 22,
          child: Text("Welcome!",
              style: TextStyle(
                  fontSize: 32,
                  color: colorclass.grey,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Poppins")),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height / 32,
          left: MediaQuery.of(context).size.width / 1.24,
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                color: colorclass.palewhite,
                borderRadius: BorderRadius.circular(6)),
            child: Icon(
              Icons.notifications_active_outlined,
              color: colorclass.grey,
              size: 38,
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height / 8,
          left: MediaQuery.of(context).size.width / 24,
          right: MediaQuery.of(context).size.width / 16,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: TextField(
              controller: _searchController,
              style: textclass.heading1,
              decoration: InputDecoration(
                prefixIcon: IconButton(
                  icon: Icon(
                    Icons.search,
                    color: colorclass.green,
                  ),
                  onPressed: () {},
                ),
                hintText: 'Search For Items',
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
        ),
        Positioned(
          top: MediaQuery.of(context).size.height / 4.6,
          left: MediaQuery.of(context).size.width / 24,
          right: MediaQuery.of(context).size.width / 16,
          child: Container(
            height: MediaQuery.of(context).size.height / 6,
            width: MediaQuery.of(context).size.width / 1.2,
            decoration: BoxDecoration(
                color: colorclass.palewhite,
                borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.only(left: 38, top: 22.0),
              child: Text(
                """Choose, Negotiate And Seal The Deal!""",
                style: textclass.title,
              ),
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height / 2.44,
          left: MediaQuery.of(context).size.width / 24,
          right: MediaQuery.of(context).size.width / 16,
          child: Text("Categories", style: textclass.title),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height / 2.38,
          left: MediaQuery.of(context).size.width / 1.30,
          child: InkWell(
              onTap: () {
                // selectedPos = selectedPos + 1;
              },
              child: Text("View All", style: textclass.viewall)),
        ),
        Positioned(
            top: MediaQuery.of(context).size.height / 2,
            left: 0,
            right: 0,
            child: FutureBuilder(
              future: _fetchAllCategoriesFromAPI(""),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  List<Category>? all_categories = snapshot.data;
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(all_categories!.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ProductListPage(
                                        catId: all_categories[index]
                                            .categoryId
                                            .toString(),
                                      )));
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height / 3.2,
                              width: MediaQuery.of(context).size.width / 2,
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
                                    child: Image.network(
                                        all_categories[index].imgUrl),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    all_categories[index].categoryName,
                                    style: textclass.heading1,
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  );
                }
              },
            ))
      ],
    );
  }
}

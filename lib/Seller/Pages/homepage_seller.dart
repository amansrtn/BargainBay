// ignore_for_file: unnecessary_const, avoid_unnecessary_containers, no_leading_underscores_for_local_identifiers
import 'dart:convert';

import 'package:bhashini/Seller/Classes/text_class.dart';
import 'package:bhashini/Seller/Pages/additem.dart';
import 'package:bhashini/Seller/Pages/entrypage_seller.dart';
import 'package:bhashini/Seller/Pages/itemlist.dart';
import 'package:bhashini/Seller/Serlializers/category_serializer.dart';
import 'package:bhashini/Global/default_token.dart';
import 'package:bhashini/Seller/Widgets/homepage_gridItem.dart';
import 'package:bhashini/Seller/Widgets/pageselector.dart';
import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomePageSeller extends StatefulWidget {
  const HomePageSeller({super.key});

  @override
  State<HomePageSeller> createState() => _HomePageSellerState();
}

class _HomePageSellerState extends State<HomePageSeller> {
  Future<List<Category>> _fetchCategoriesFromAPI() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? DEFAULT_TOKEN = pref.getString('accessToken');
    final response = await http.post(
      Uri.parse('$API/api/seller/categories/'),
      body: {'contains': ""},
      headers: {'Authorization': 'Bearer $DEFAULT_TOKEN'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['result'];
      return data.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  var gridItem = const [
    GridItem(
      heading: "Product",
      subHeading: "50",
      icon: Icons.inventory_2_rounded,
    ),
    GridItem(
      heading: "Rating",
      subHeading: "5.0",
      icon: Icons.star,
    ),
    GridItem(
      heading: "Total Orders",
      subHeading: "100",
      icon: Icons.delivery_dining_rounded,
    ),
    GridItem(
      heading: "Total Sale",
      subHeading: "100",
      icon: Icons.currency_rupee_rounded,
    ),
  ];
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
        ),
        Positioned(
          top: MediaQuery.of(context).size.height / 4.6,
          left: MediaQuery.of(context).size.width / 24,
          right: MediaQuery.of(context).size.width / 16,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(gridItem.length, (index) {
                return gridItem[index];
              }),
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height / 2.3,
          left: MediaQuery.of(context).size.width / 24,
          right: MediaQuery.of(context).size.width / 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Categories You Deal Into!", style: textclass.heading1),
              InkWell(
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => EntryPageSeller(selectedPos: 1)));
                  },
                  child: Text("View All", style: textclass.viewall)),
            ],
          ),
        ),
        Positioned(
            top: MediaQuery.of(context).size.height / 2,
            left: 0,
            right: 0,
            child: FutureBuilder(
              future: _fetchCategoriesFromAPI(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  List<Category>? categories_seller_deals = snapshot.data;
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(categories_seller_deals!.length,
                          (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ProductListPage(
                                        catId: categories_seller_deals[index]
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
                                        categories_seller_deals[index].imgUrl),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    categories_seller_deals[index].categoryName,
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

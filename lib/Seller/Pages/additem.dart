// ignore_for_file: must_be_immutable, unused_local_variable, library_private_types_in_public_api, avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:bhashini/Seller/Serlializers/category_serializer.dart';
import 'package:bhashini/Global/default_token.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NewProductForm extends StatefulWidget {
  final Function(
          String category, String name, double price, int quantity, File? image)
      onSubmit;

  NewProductForm({Key? key, required this.onSubmit, required this.catId})
      : super(key: key);
  String catId;
  @override
  _NewProductFormState createState() => _NewProductFormState();
}

class _NewProductFormState extends State<NewProductForm> {
  final _formKey = GlobalKey<FormState>();
  final _categoryController = TextEditingController();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  File? _imageFile;

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

  // Improved image selection with error handling
  Future<void> _pickImage() async {
    try {
      final pickedImageFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      setState(() {
        if (pickedImageFile != null) {
          _imageFile = File(pickedImageFile.path);
        }
      });
    } on Exception catch (e) {
      // Handle errors like permission denial
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: $e'),
        ),
      );
    }
  }

  bool isSending = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Product'),
      ),
      body: FutureBuilder<List<Category>>(
          future: _fetchAllCategoriesFromAPI(""),
          builder:
              (BuildContext context, AsyncSnapshot<List<Category>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData && snapshot.data!.isEmpty) {
              return const Center(
                child: Text('An Error Occured!'),
              );
            } else {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      DropdownButtonFormField<String>(
                        hint: const Text('Select Category'),
                        items: snapshot.data!.map((Category category) {
                          return DropdownMenuItem<String>(
                            value: category.categoryId.toString(),
                            child: Text(category.categoryName),
                          );
                        }).toList(),
                        onChanged: (value) => SchedulerBinding.instance
                            .addPostFrameCallback(
                                (_) => _categoryController.text = value!),
                        validator: (value) =>
                            value == null ? 'Please select a category' : null,
                      ),
                      const SizedBox(height: 10.0),
                      TextFormField(
                        controller: _nameController,
                        decoration:
                            const InputDecoration(labelText: 'Product Name'),
                        validator: (value) => value!.isEmpty
                            ? 'Please enter a product name'
                            : null,
                      ),
                      const SizedBox(height: 10.0),
                      TextFormField(
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        decoration:
                            const InputDecoration(labelText: 'Unit Price'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a price';
                          } else {
                            try {
                              double.parse(value);
                              return null;
                            } catch (e) {
                              return 'Please enter a valid price';
                            }
                          }
                        },
                      ),
                      const SizedBox(height: 10.0),
                      TextFormField(
                        controller: _quantityController,
                        keyboardType: TextInputType.number,
                        decoration:
                            const InputDecoration(labelText: 'Quantity Added'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a quantity';
                          } else {
                            try {
                              int.parse(value);
                              return null;
                            } catch (e) {
                              return 'Please enter a valid quantity';
                            }
                          }
                        },
                      ),
                      const SizedBox(height: 10.0),
                      // Improved image selection UI with preview (consider UI framework)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Product Image'),
                          TextButton(
                            onPressed: _pickImage,
                            child: const Text('Select Image'),
                          ),
                        ],
                      ),
                      if (_imageFile != null)
                        Container(
                          height: 100,
                          width: 100.0,
                          child: Image.file(_imageFile!),
                        ),
                      const SizedBox(height: 20.0),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            // Extract form values
                            final category = _categoryController.text;
                            final name = _nameController.text;
                            final price = double.parse(_priceController.text);
                            final quantity =
                                int.parse(_quantityController.text);

                            // Call onSubmit callback with form data and image (if any)
                            ApiService apiService = ApiService();
                            apiService.sendData(
                                category, name, price, quantity, _imageFile);
                            widget.onSubmit(
                                category, name, price, quantity, _imageFile);
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text('Add Product'),
                      ),
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }
}

class ApiService {
  static const String apiUrl = '';

  Future<void> sendData(
    String category,
    String name,
    double price,
    int quantity,
    File? image,
  ) async {
    // Convert image to base64 if needed
    String? base64Image;
    if (image != null) {
      List<int> imageBytes = await image.readAsBytes();
      base64Image = base64Encode(imageBytes);
    }

    Map<String, dynamic> data = {
      'category': category,
      'name': name,
      'unit_price': price,
      'quantity': quantity,
      'img_url': "https://th.bing.com/th/id/OIG1.rs2VG.CuvGpCTGVWB3.u?pid=ImgGn"
    };
    print(json.encode(data));

    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? DEFAULT_TOKEN = pref.getString('accessToken');
      final response = await http.post(Uri.parse('$API/api/seller/addprod/'),
          body: json.encode(data),
          headers: {
            'Authorization': 'Bearer $DEFAULT_TOKEN',
            'Content-Type': 'application/json'
          });

      if (response.statusCode == 200) {
        const SnackBar(content: Text("Successfully Saved!"));
      } else {
        // Handle failure
        const SnackBar(content: Text("Unable to save"));
        throw Exception('Failed to send data');
      }
    } catch (e) {
      // Handle network errors
      throw Exception('Network error: $e');
    }
  }
}

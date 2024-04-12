// ignore_for_file: camel_case_types, non_constant_identifier_names, avoid_print, unnecessary_new, body_might_complete_normally_nullable, unnecessary_brace_in_string_interps, use_build_context_synchronously

import 'dart:convert';

import 'package:bhashini/Global/default_token.dart';
import 'package:bhashini/Seller/Pages/entrypage_seller.dart';
import 'package:bhashini/Auth/constants.dart';
import 'package:bhashini/Auth/signup_page.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class form_page extends StatefulWidget {
  const form_page({super.key});

  @override
  State<form_page> createState() => _form_pageState();
}

class _form_pageState extends State<form_page> {
  TextEditingController dateinput = TextEditingController();
  TextEditingController fName = TextEditingController();
  TextEditingController lName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phonenumber = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController landmark = TextEditingController();
  TextEditingController postalcode = TextEditingController();
  TextEditingController cmpname = TextEditingController();
  bool _validate = false;
  bool _valiname = false;
  final _formKey = GlobalKey<FormState>();
  var gender = ['Male', 'Female', 'Other'];
  var vendortype = ['Wholeseller', 'Retailer'];
  var lang = [
    "Angika",
    "Assamese",
    "Awadhi",
    "Bengali",
    "Bhojpuri",
    "Bihari",
    "Bodo",
    "Bundeli",
    "Chhattisgarhi",
    "Dogri",
    "English",
    "Garhwali",
    "Garo",
    "Goan Konkani",
    "Gujarati",
    "Halbi",
    "Hindi",
    "Kannada",
    "Kashmiri",
    "Khasi",
    "Konkani",
    "Lushai",
    "Magahi",
    "Maithili",
    "Malayalam",
    "Manipuri",
    "Marathi",
    "Marwari",
    "Nepali",
    "Ngungwel",
    "Odia",
    "Panim",
    "Punjabi",
    "Rajasthani",
    "Sanskrit",
    "Santali",
    "Sarjapuri",
    "Sindhi",
    "Sinhala",
    "Tamil",
    "Telugu",
    "Tulu",
    "Urdu",
  ];
  Map<String, String> langcode = {
    "Angika": "anp",
    "Assamese": "as",
    "Awadhi": "awa",
    "Bengali": "bn",
    "Bhojpuri": "bho",
    "Bihari": "bih",
    "Bodo": "brx",
    "Bundeli": "bns",
    "Chhattisgarhi": "hne",
    "Dogri": "dooi",
    "English": "en",
    "Garhwali": "gbm",
    "Garo": "grt",
    "Goan Konkani": "gom",
    "Gujarati": "gu",
    "Halbi": "hlb",
    "Hindi": "hi",
    "Kannada": "kn",
    "Kashmiri": "ks",
    "Khasi": "kha",
    "Konkani": "kok",
    "Lushai": "lus",
    "Magahi": "mag",
    "Maithili": "mai",
    "Malayalam": "ml",
    "Manipuri": "mni",
    "Marathi": "mr",
    "Marwari": "mwr",
    "Nepali": "ne",
    "Ngungwel": "njz",
    "Odia": "or",
    "Panim": "pnr",
    "Punjabi": "pa",
    "Rajasthani": "raj",
    "Sanskrit": "sa",
    "Santali": "sat",
    "Sarjapuri": "sjp",
    "Sindhi": "sd",
    "Sinhala": "si",
    "Tamil": "ta",
    "Telugu": "te",
    "Tulu": "tcy",
    "Urdu": "ur",
  };
  String laninput = "English";
  String input_lancode = "";
  String vendor = 'Wholeseller';
  String genderval = 'Male';

  int calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    if (birthDate.month > currentDate.month) {
      age--;
    } else if (currentDate.month == birthDate.month) {
      if (birthDate.day > currentDate.day) {
        age--;
      }
    }
    return age;
  }

  savedata() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("Lang", input_lancode);
    await prefs.setString("Gender", genderval);
    await prefs.setString("username", fName.text);
    await prefs.setString("user_email", email.text);
  }

  settoken(String accessToken, String refreshToken, String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', accessToken);
    await prefs.setString('refreshToken', refreshToken);
    await prefs.setString('username', username);
  }

  Future<String> _loginAPI(String username, String password) async {
    final response = await http.post(
      Uri.parse('$API/api/token/'),
      body: {
        'username': username,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final refreshToken = json.decode(response.body)['refresh'];
      final accessToken = json.decode(response.body)['access'];
      print(accessToken);

      settoken(accessToken, refreshToken, username);

      return "SUCCESS LOGIN";
    } else {
      return "FAILURE LOGIN";
    }
  }

  Future<String> _signupAPI() async {
    final response = await http.post(
      Uri.parse('$API/api/auth/signup/'),
      body: {
        'username': SignupPage.phone,
        'first_name': fName.text,
        'last_name': lName.text,
        'dob': dateinput.text,
        'state': state.text,
        'city': city.text,
        'address': address.text,
        'postal': postalcode.text,
        'gender': genderval,
        'password': 'buyer${SignupPage.phone}',
        'type': 'seller',
        'phone': SignupPage.phone,
        'company_name': cmpname.text,
        'dim': vendor,
        'email': email.text,
      },
    );

    if (response.statusCode == 201) {
      String username = json.decode(response.body)['username'];
      String password = 'buyer${SignupPage.phone}';
      String loginResponse = await _loginAPI(username, password);
      if (loginResponse != "SUCCESS LOGIN") {
        return "ERROR";
      }
      return "SUCCESS";
    } else {
      return "ERROR";
    }
  }

  formfield() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: fName,
            validator: (value) {
              final nameRegExp = new RegExp(r"^\s*([A-Za-z])");
              if (!nameRegExp.hasMatch(value!)) {
                return "Enter a valid name";
              }
            },
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              icon: const Icon(Icons.person),
              hintText: 'First name',
              labelText: 'First Name',
            ),
          ),
          SizedBox(
            height: getUnitHeight(context),
          ),
          Padding(
            padding: EdgeInsets.only(left: getUnitWidth(context) * 10),
            child: TextFormField(
              controller: lName,
              validator: (value) {
                final nameRegExp = new RegExp(r"[A-Za-z]");
                if (!nameRegExp.hasMatch(value!)) {
                  return "Enter a valid name";
                }
              },
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                // icon: const Icon(Icons.person),
                hintText: 'Last name',
                labelText: 'Last Name',
              ),
            ),
          ),
          SizedBox(
            height: getUnitHeight(context) * 3,
          ),
          // TextFormField(
          //   validator: (value) {
          //     String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
          //     RegExp regExp = new RegExp(patttern);
          //     if (value?.length == 0) {
          //       return 'Please enter mobile number';
          //     } else if (!regExp.hasMatch(value!)) {
          //       return 'Please enter valid mobile number';
          //     }
          //     return null;
          //   },
          //   keyboardType: TextInputType.number,
          //   decoration: InputDecoration(
          //     border:
          //         OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
          //     icon: const Icon(Icons.phone),
          //     hintText: 'Enter a phone number',
          //     labelText: 'Phone',
          //   ),
          // ),
          // SizedBox(
          //   height: getUnitHeight(context) * 1.5,
          // ),
          TextFormField(
            style: TextStyle(color: black),
            controller: dateinput, //editing controller of this TextField
            decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                labelStyle: TextStyle(color: black),
                icon: const Icon(Icons.calendar_month_sharp),
                iconColor: black, //icon of text field
                labelText: "Enter Date Of Birth" //label text of field
                ),
            readOnly:
                true, //set it true, so that user will not able to edit text
            validator: (value) {
              if (calculateAge(DateTime.parse(value!)) < 18 || value.isEmpty) {
                return 'Age should be above 18';
              }
              return null;
            },
            onTap: () async {
              const Duration(milliseconds: 400);
              DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(
                      1900), //DateTime.now() - not to allow to choose before today.
                  lastDate: DateTime(2040));
              if (pickedDate != null) {
                // print(
                //     pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                // String formattedDate =
                //     DateFormat('dd-MM-yyyy').format(pickedDate);
                // print(
                //     formattedDate); //formatted date output using intl package =>  2021-03-16
                //you can implement different kind of Date Format here according to your requirement
                setState(
                    () => dateinput.text = pickedDate.toString().split(" ")[0]);
                // print("yo" + dateinput.text);
              } else {
                print("Date is not selected");
              }
            },
          ),
          SizedBox(
            height: getUnitHeight(context) * 3,
          ),
          TextFormField(
            controller: email,
            validator: (value) {
              final emailRegExp =
                  RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
              if (!emailRegExp.hasMatch(value!)) {
                return "Enter a valid email id";
              }
            },
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              icon: const Icon(Icons.person),
              hintText: 'Enter your email',
              labelText: 'Email Id',
            ),
          ),
          SizedBox(
            height: getUnitHeight(context) * 3,
          ),
          TextFormField(
            controller: state,
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              icon: const Icon(Icons.home),
              hintText: "Enter your State",
              errorText: _validate ? "This field Can't Be Empty" : null,
            ),
          ),
          SizedBox(
            height: getUnitHeight(context),
          ),
          Padding(
            padding: EdgeInsets.only(left: getUnitWidth(context) * 10),
            child: TextFormField(
              controller: city,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                // icon: const Icon(Icons.home),
                hintText: "Enter your City",
                errorText: _validate ? "This field Can't Be Empty" : null,
              ),
            ),
          ),
          SizedBox(
            height: getUnitHeight(context),
          ),
          Padding(
            padding: EdgeInsets.only(left: getUnitWidth(context) * 10),
            child: TextFormField(
              controller: address,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                // icon: const Icon(Icons.home),
                hintText: "Enter your Address",
                errorText: _validate ? "This field Can't Be Empty" : null,
              ),
            ),
          ),
          SizedBox(
            height: getUnitHeight(context),
          ),
          Padding(
            padding: EdgeInsets.only(left: getUnitWidth(context) * 10),
            child: TextFormField(
              controller: landmark,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                // icon: const Icon(Icons.home),
                hintText: "Enter a landmark",
                errorText: _validate ? "This field Can't Be Empty" : null,
              ),
            ),
          ),
          SizedBox(
            height: getUnitHeight(context),
          ),
          Padding(
            padding: EdgeInsets.only(left: getUnitWidth(context) * 10),
            child: TextFormField(
              controller: postalcode,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                // icon: const Icon(Icons.home),
                hintText: "Enter your postal code",
                errorText: _validate ? "This field Can't Be Empty" : null,
              ),
            ),
          ),

          SizedBox(
            height: getUnitHeight(context) * 3,
          ),
          TextFormField(
            controller: cmpname,
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              icon: const Icon(Icons.business_outlined),
              hintText: "Enter your comapny name",
              errorText: _valiname ? "Name Can't Be Empty" : null,
            ),
          ),
          SizedBox(
            height: getUnitHeight(context) * 1.5,
            width: getUnitWidth(context) * 2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                  padding: EdgeInsets.only(right: getUnitWidth(context) * 2)),
              const Text(
                "Gender: ",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              DropdownButton(
                // Initial Value
                value: genderval,
                hint: const Text("Gender"),
                alignment: Alignment.centerLeft,
                // Down Arrow Icon
                icon: const Icon(Icons.keyboard_arrow_down),

                // Array list of items
                items: gender.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
                // After selecting the desired option,it will
                // change button value to selected value
                onChanged: (String? newValue) {
                  setState(() {
                    genderval = newValue!;
                  });
                  print(genderval);
                },
              ),
              Padding(
                  padding: EdgeInsets.only(right: getUnitWidth(context) * 7)),
              const Text(
                "Type: ",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              DropdownButton(
                // Initial Value
                value: vendor,
                hint: const Text("Vendor Type"),
                alignment: Alignment.center,
                // Down Arrow Icon
                icon: const Icon(Icons.keyboard_arrow_down),

                // Array list of items
                items: vendortype.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
                // After selecting the desired option,it will
                // change button value to selected value
                onChanged: (String? newValue) {
                  setState(() {
                    vendor = newValue!;
                  });
                  print(vendor);
                },
              ),
            ],
          ),
          Padding(padding: EdgeInsets.only(right: getUnitWidth(context) * 3)),
          Row(
            children: [
              const Text(
                "Select Language: ",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              DropdownButton(
                // Initial Value
                value: laninput,
                hint: const Text("Choose Language"),
                alignment: Alignment.center,
                // Down Arrow Icon
                icon: const Icon(Icons.keyboard_arrow_down),

                // Array list of items
                items: lang.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
                // After selecting the desired option,it will
                // change button value to selected value
                onChanged: (String? newValue) {
                  setState(() {
                    laninput = newValue!;
                  });
                  input_lancode = langcode[laninput]!;
                  print(laninput);
                  print(input_lancode);
                },
              ),
            ],
          ),

          SizedBox(
            height: getUnitHeight(context) * 1.5,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                print(dateinput.text);
                savedata();
                if (_formKey.currentState!.validate()) {
                  String response = await _signupAPI();
                  print("#######3${response}");
                  if (response == 'SUCCESS') {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => EntryPageSeller(
                              selectedPos: 0,
                            )));
                  } else {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SignupPage()));
                  }
                }
                setState(() {
                  _validate = address.text.isEmpty;
                  _valiname = cmpname.text.isEmpty;
                });
              },
              child: const Text('Submit'),
            ),
          ),
          SizedBox(
            height: getUnitHeight(context) * 2,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          toolbarHeight: 60.2,
          toolbarOpacity: 0.8,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(25),
                bottomLeft: Radius.circular(25)),
          ),
          backgroundColor: greenColor,
          title: Text(
            "Registration Form",
            style: TextStyle(color: white),
          ),
        ),
        backgroundColor: white,
        body: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(getUnitWidth(context) * 3,
                getUnitHeight(context) * 3, getUnitWidth(context) * 5, 0),
            child: SafeArea(
              child: Column(
                children: [
                  formfield(),
                ],
              ),
            )),
      ),
    );
  }
}

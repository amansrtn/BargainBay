import 'package:shared_preferences/shared_preferences.dart';

// await prefs.setString("Lang", input_lancode);
// await prefs.setString("Gender", genderval);
// await prefs.setString("username", fName.text);
// await prefs.setString("user_email",email.text);

Future<String?> sellergetname() async {
  final prefs = await SharedPreferences.getInstance();
  String? get = prefs.getString("username");
  return get;
}

Future<String?> sellergetlang() async {
  final prefs = await SharedPreferences.getInstance();
  String? get = prefs.getString("Lang");
  return get;
}

Future<String?> sellergetusertype() async {
  final prefs = await SharedPreferences.getInstance();
  String? get = prefs.getString("Gender");
  return get;
}

Future<String?> sellergetuseremail() async {
  final prefs = await SharedPreferences.getInstance();
  String? get = prefs.getString("user_email");
  return get;
}




Future<String?> buyergetname() async {
  final prefs = await SharedPreferences.getInstance();
  String? get = prefs.getString("buyer_username");
  return get;
}

Future<String?> buyergetlang() async {
  final prefs = await SharedPreferences.getInstance();
  String? get = prefs.getString("buyer_Lang");
  return get;
}

Future<String?> buyergetusertype() async {
  final prefs = await SharedPreferences.getInstance();
  String? get = prefs.getString("buyer_Gender");
  return get;
}

Future<String?> buyergetuseremail() async {
  final prefs = await SharedPreferences.getInstance();
  String? get = prefs.getString("buyer_email");
  return get;
}

Future<bool?> type() async {
  final prefs = await SharedPreferences.getInstance();
  bool? get = prefs.getBool("usertype");
  return get;
}

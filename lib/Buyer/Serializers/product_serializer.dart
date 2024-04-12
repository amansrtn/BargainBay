// ignore_for_file: non_constant_identifier_names

class Product {
  final String prodId;
  final String prodName;
  final String unitPrice;
  final String image;
  final String sellerUName; // seller username
  final String sellerFName; //seller first name
  final String sellerLName; //seller last name
  final String sellerPhone;
  final String catId;
  final String catName; // category name and id
  final String seller_email; 
  final String seller_gender; 
  final String seller_lang;
  Product( {
    required this.prodId,
    required this.prodName,
    required this.unitPrice,
    required this.sellerUName,
    required this.sellerFName,
    required this.sellerLName,
    required this.sellerPhone,
    required this.catId,
    required this.catName,
    required this.image,
    required this.seller_email,
    required this.seller_gender,
    required this.seller_lang
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      prodId: json['prod_id'],
      prodName: json['name'],
      unitPrice: json['unit_price'].toString(),
      sellerUName: json['seller_uname'],
      sellerFName: json['seller_fname'],
      sellerLName: json['seller_lname'],
      sellerPhone: json['seller_phone'],
      catId: json['category_id'],
      catName: json['category_name'],
      image: json['img_url'],
      seller_email:json['seller_email'] ,
      seller_gender : json["seller_gender"],
      seller_lang:"hi"
    );
  }
}

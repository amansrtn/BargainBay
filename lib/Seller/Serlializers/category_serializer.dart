class Category {
  final String categoryName;
  final int categoryId;
  final String imgUrl;

  Category({
    required this.categoryName,
    required this.categoryId,
    required this.imgUrl,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryName: json['category_name'],
      categoryId: json['category_id'],
      imgUrl: json['img_url'],
    );
  }
}

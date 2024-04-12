final List<String> all_categories = [
  'Fruits',
  'Vegetables',
  'Meat & Seafood',
  'Dairy & Eggs',
  'Bakery',
  'Pantry Staples',
  'Beverages',
  'Snacks',
  'Frozen Foods',
  'Clothes',
  'Shoes',
  'Beauty',
  'Electronics',
  'Home',
  'Stationery',
  'Games',
];

List<String> getCategories(String prefix) {
  List<String> res = [];

  for (String element in all_categories) {
    if (element.toLowerCase().startsWith(prefix.toLowerCase())) {
      res.add(element);
    }
  }

  return res;
}

final List<String> categories_seller_currently_deals_into = [
  'Fruits',
  'Vegetables',
  'Meat & Seafood',
  'Dairy & Eggs',
  'Bakery',
  'Pantry Staples',
  'Beverages',
  'Snacks',
  'Frozen Foods',
  'Clothes',
  'Shoes',
  'Beauty',
  'Electronics',
  'Home',
  'Stationery',
  'Games',
];

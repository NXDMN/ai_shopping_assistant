class Product {
  final String id;
  final String name;
  final String description;
  final List<String> images;
  final int stock;
  final double price;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.images,
    required this.stock,
    required this.price,
  });

  Product.fromJson(Map<String, dynamic> data)
      : id = data['id'],
        name = data['name'],
        description = data['description'],
        images = List.castFrom<dynamic, String>(data['images']),
        stock = data['stock'],
        price = double.parse(data['price'].toString());

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'images': images,
        'stock': stock,
        'price': price,
      };
}

class FavouriteProduct {
  final String id;
  final String name;
  final String image;
  final double price;
  bool notification;

  FavouriteProduct({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.notification,
  });

  FavouriteProduct.fromJson(Map<String, dynamic> data)
      : id = data['id'],
        name = data['name'],
        image = data['image'],
        price = double.parse(data['price'].toString()),
        notification = data['notification'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'image': image,
        'price': price,
        'notification': notification,
      };
}

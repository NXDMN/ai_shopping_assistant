class CartProduct {
  final String id;
  final String name;
  final String image;
  final double price;
  int quantity;

  CartProduct({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.quantity,
  });

  CartProduct.fromJson(Map<String, dynamic> data)
      : id = data['id'],
        name = data['name'],
        image = data['image'],
        price = double.parse(data['price'].toString()),
        quantity = data['quantity'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'image': image,
        'price': price,
        'quantity': quantity,
      };
}

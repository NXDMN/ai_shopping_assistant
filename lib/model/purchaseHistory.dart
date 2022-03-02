import 'package:ai_shopping_assistant/model/cartProduct.dart';

class PurchaseHistory {
  final String id;
  final String date;
  final String address;
  final double total;
  final List<CartProduct> products;

  PurchaseHistory({
    required this.id,
    required this.date,
    required this.address,
    required this.total,
    required this.products,
  });

  PurchaseHistory.fromJson(Map<String, dynamic> data)
      : id = data['id'],
        date = data['date'],
        address = data['address'],
        total = double.parse(data['total'].toString()),
        products = data['products']
            .map<CartProduct>((e) => CartProduct.fromJson(e))
            .toList();

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date,
        'address': address,
        'total': total,
        'products': products.map((e) => e.toJson()).toList(),
      };
}

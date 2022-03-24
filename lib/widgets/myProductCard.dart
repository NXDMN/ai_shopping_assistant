import 'package:ai_shopping_assistant/constants.dart';
import 'package:ai_shopping_assistant/model/product.dart';
import 'package:ai_shopping_assistant/screens/product_details/view/product_details_screen.dart';
import 'package:flutter/material.dart';

class MyProductCard extends StatelessWidget {
  final Product product;

  MyProductCard({
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        margin: EdgeInsets.zero,
        child: Container(
          height: 212.0,
          width: 180.0,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                height: 130,
                width: 110,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(product.images[0]))),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: MyTextStyle.small,
                ),
              ),
              Text(
                'RM ${product.price.toStringAsFixed(2)}',
                style: MyTextStyle.small,
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.pushNamed(
          context,
          ProductDetailsScreen.id,
          arguments: ProductDetailsScreenArguments(productId: product.id),
        );
      },
    );
  }
}

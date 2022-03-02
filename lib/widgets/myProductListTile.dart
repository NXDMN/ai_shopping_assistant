import 'package:ai_shopping_assistant/constants.dart';
import 'package:ai_shopping_assistant/model/cartProduct.dart';
import 'package:flutter/material.dart';

class MyProductListTile extends StatelessWidget {
  final CartProduct cartProduct;

  MyProductListTile({required this.cartProduct});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170.0,
      child: ListTile(
        contentPadding: const EdgeInsets.all(20.0),
        minVerticalPadding: 0,
        title: Row(
          children: [
            Container(
              height: 130,
              width: 110,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(cartProduct.image),
                ),
              ),
            ),
            const SizedBox(
              width: 10.0,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cartProduct.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: MyTextStyle.small,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    'x ${cartProduct.quantity}',
                    style: MyTextStyle.small,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            Text(
              'RM ${(cartProduct.price * cartProduct.quantity).toStringAsFixed(2)}',
              style: MyTextStyle.small,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:ai_shopping_assistant/constants.dart';
import 'package:flutter/material.dart';

class MyCalculationList extends StatelessWidget {
  final double subtotal;
  final double deliveryFee;
  final double total;

  MyCalculationList({
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          title: const Text(
            'Subtotal',
            style: MyTextStyle.mediumBold,
          ),
          trailing: Container(
            width: 100.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'RM',
                  style: MyTextStyle.mediumSmall,
                ),
                Text(
                  subtotal.toStringAsFixed(2),
                  style: MyTextStyle.mediumSmall,
                ),
              ],
            ),
          ),
        ),
        ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          title: const Text(
            'Delivery fee',
            style: MyTextStyle.mediumBold,
          ),
          trailing: Container(
            width: 100.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'RM',
                  style: MyTextStyle.mediumSmall,
                ),
                Text(
                  deliveryFee.toStringAsFixed(2),
                  style: MyTextStyle.mediumSmall,
                ),
              ],
            ),
          ),
        ),
        ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          title: const Text(
            'Total',
            style: MyTextStyle.mediumBold,
          ),
          trailing: Container(
            width: 100.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'RM',
                  style: MyTextStyle.mediumSmall,
                ),
                Text(
                  total.toStringAsFixed(2),
                  style: MyTextStyle.mediumSmall,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

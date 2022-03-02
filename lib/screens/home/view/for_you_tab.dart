import 'package:ai_shopping_assistant/model/product.dart';
import 'package:ai_shopping_assistant/screens/home/view_model/home_model.dart';
import 'package:ai_shopping_assistant/widgets/myProductCard.dart';
import 'package:flutter/material.dart';

class ForYouTab extends StatefulWidget {
  final HomeModel model;

  ForYouTab({
    required this.model,
  });

  @override
  _ForYouTabState createState() => _ForYouTabState();
}

class _ForYouTabState extends State<ForYouTab> {
  HomeModel get _model => widget.model;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.85,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                Product product = _model.productList[index];

                return MyProductCard(product: product);
              },
              childCount: _model.productList.length,
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:ai_shopping_assistant/widgets/myProductCard.dart';
import 'package:flutter/material.dart';

class ForYouTab extends StatefulWidget {
  const ForYouTab({Key? key}) : super(key: key);

  @override
  _ForYouTabState createState() => _ForYouTabState();
}

class _ForYouTabState extends State<ForYouTab> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.9,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return MyProductCard();
              },
              childCount: 10,
            ),
          ),
        ),
      ],
    );
  }
}

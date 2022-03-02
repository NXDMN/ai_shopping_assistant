import 'package:ai_shopping_assistant/screens/home/view_model/home_model.dart';
import 'package:ai_shopping_assistant/widgets/myProductCard.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ai_shopping_assistant/constants.dart';
import 'package:ai_shopping_assistant/model/product.dart';
import 'package:provider/provider.dart';

class HomeTab extends StatefulWidget {
  final HomeModel model;

  HomeTab({
    required this.model,
  });

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  HomeModel get _model => widget.model;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: CarouselSlider(
            options: CarouselOptions(
              height: 130.0,
              viewportFraction: 1.0,
              autoPlay: true,
            ),
            items: [1, 2, 3]
                .map((i) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('${imagePath}banner$i.jpg'),
                            fit: BoxFit.fill),
                      ),
                    ))
                .toList(),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(20.0),
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

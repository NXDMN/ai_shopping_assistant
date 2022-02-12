import 'package:ai_shopping_assistant/widgets/myProductCard.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
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
                            image: AssetImage('assets/images/banner$i.jpg'),
                            fit: BoxFit.fill),
                      ),
                    ))
                .toList(),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.all(20.0),
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

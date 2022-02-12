import 'package:ai_shopping_assistant/constants.dart';
import 'package:ai_shopping_assistant/screens/add_to_cart_sheet.dart';
import 'package:ai_shopping_assistant/widgets/myOutlinedButton.dart';
import 'package:ai_shopping_assistant/widgets/myProductCard.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ai_shopping_assistant/widgets/constants.dart';

class ProductDetailsScreen extends StatefulWidget {
  static const id = 'product_details_screen';

  const ProductDetailsScreen({Key? key}) : super(key: key);

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  List<String> imgList = [
    'assets/images/Men Clothes.jpg',
    'assets/images/Women Clothes.jpeg',
    'assets/images/Men Clothes.jpg',
  ];
  int current = 0;
  final CarouselController _controller = CarouselController();

  List<Widget> _buildImageCarousel() {
    return [
      CarouselSlider(
        carouselController: _controller,
        options: CarouselOptions(
          height: 300.0,
          viewportFraction: 1.0,
          onPageChanged: (index, reason) {
            setState(() {
              current = index;
            });
          },
        ),
        items: imgList
            .map((i) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(i),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Container(),
                ))
            .toList(),
      ),
      SizedBox(
        height: 10.0,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: imgList.asMap().entries.map((entry) {
          return GestureDetector(
            onTap: () => _controller.animateToPage(entry.key),
            child: Container(
              width: 12.0,
              height: 12.0,
              margin:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black
                      .withOpacity(current == entry.key ? 0.9 : 0.4)),
            ),
          );
        }).toList(),
      ),
    ];
  }

  Widget _buildParagraph(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: MyTextStyle.mediumBold,
        ),
        SizedBox(
          height: 15.0,
        ),
        Wrap(
          children: [
            Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam fermentum arcu nisl, at luctus metus porta gravida. Pellentesque rutrum turpis ultrices justo malesuada imperdiet. Donec nec accumsan ex, non semper nibh. Aenean faucibus vehicula lacus quis dapibus. Pellentesque et interdum lectus, efficitur sagittis elit. Morbi pretium convallis consectetur. Duis mattis turpis in vehicula mollis. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent ut auctor nunc, vel laoreet ante. Maecenas sed metus at nulla tincidunt porttitor. Suspendisse mattis ornare massa, vel ornare nisi luctus quis. Vivamus cursus ligula non orci ornare, ut efficitur lorem euismod.')
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              floating: true,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.share,
                  ),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(
                    Icons.shopping_cart,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  ..._buildImageCarousel(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nike Air Max',
                              style: MyTextStyle.largeBold,
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Text(
                              'RM 300.00',
                              style: MyTextStyle.mediumBold,
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Text(
                              'In stock: 20',
                              style: MyTextStyle.small,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const MyDivider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 20.0),
                    child: _buildParagraph('Product details'),
                  ),
                  const MyDivider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 20.0),
                    child: _buildParagraph('Delivery services'),
                  ),
                  const MyDivider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Similar products',
                          style: MyTextStyle.mediumBold,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        SizedBox(
                          height: 200.0,
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: MyProductCard(),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const MyDivider(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 15.0),
                    child: Text(
                      'You may also like',
                      style: MyTextStyle.mediumBold,
                    ),
                  ),
                ],
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 80.0),
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
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xff81D3F8),
        label: const Text('Add to cart'),
        icon: const Icon(Icons.add_shopping_cart),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => AddToCartSheet(),
          );
        },
      ),
    );
  }
}

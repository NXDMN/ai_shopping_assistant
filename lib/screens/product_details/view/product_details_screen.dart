import 'package:ai_shopping_assistant/constants.dart';
import 'package:ai_shopping_assistant/model/product.dart';
import 'package:ai_shopping_assistant/screens/product_details/view/add_to_cart_sheet.dart';
import 'package:ai_shopping_assistant/screens/cart/view/cart_screen.dart';
import 'package:ai_shopping_assistant/screens/product_details/view_model/product_details_model.dart';
import 'package:ai_shopping_assistant/widgets/myOutlinedButton.dart';
import 'package:ai_shopping_assistant/widgets/myProductCard.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ai_shopping_assistant/widgets/constants.dart';
import 'package:provider/provider.dart';

class ProductDetailsScreenArguments {
  final String productId;

  ProductDetailsScreenArguments({required this.productId});
}

class ProductDetailsScreen extends StatefulWidget {
  static const id = 'product_details_screen';

  final ProductDetailsScreenArguments args;

  ProductDetailsScreen({
    required this.args,
  });

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  String get _productId => widget.args.productId;
  late ProductDetailsModel _model;

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
        items: _model.product.images
            .map((i) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(i),
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
        children: _model.product.images.asMap().entries.map((entry) {
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

  Widget _buildParagraph(bool isDescription) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isDescription ? 'Product details' : 'Delivery services',
          style: MyTextStyle.mediumBold,
        ),
        const SizedBox(
          height: 15.0,
        ),
        Wrap(
          children: [
            Text(
              isDescription
                  ? _model.product.description
                  : 'Standard delivery fee of RM 10.00 will be added.',
              style: MyTextStyle.small,
            ),
          ],
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _model = ProductDetailsModel(_productId);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _model,
      child: Consumer<ProductDetailsModel>(
        builder: (context, model, child) => Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: model.isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : CustomScrollView(
                    slivers: <Widget>[
                      SliverAppBar(
                        elevation: 0.0,
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
                            onPressed: () async {
                              await model.shareProduct();
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.shopping_cart,
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, CartScreen.id);
                            },
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
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _model.product.name,
                                    maxLines: 10,
                                    style: MyTextStyle.largeBold,
                                  ),
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                  Text(
                                    'RM ${_model.product.price.toStringAsFixed(2)}',
                                    style: MyTextStyle.mediumBold,
                                  ),
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                  Text(
                                    'In stock: ${_model.product.stock}',
                                    style: MyTextStyle.small,
                                  ),
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                  GestureDetector(
                                    child: Icon(model.isFavourite
                                        ? Icons.favorite
                                        : Icons.favorite_border),
                                    onTap: () async {
                                      await model.updateFavourite();
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const MyDivider(),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20.0, horizontal: 20.0),
                              child: _buildParagraph(true),
                            ),
                            const MyDivider(),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20.0, horizontal: 20.0),
                              child: _buildParagraph(false),
                            ),
                            const MyDivider(),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20.0, horizontal: 20.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Similar products',
                                    style: MyTextStyle.mediumBold,
                                  ),
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                  SizedBox(
                                    height: 212.0,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: const ClampingScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      itemCount:
                                          _model.similarProductList.length,
                                      itemBuilder: (context, index) {
                                        Product product =
                                            _model.similarProductList[index];
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              right: 10.0),
                                          child: MyProductCard(
                                            product: product,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const MyDivider(),
                            const Padding(
                              padding:
                                  EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 15.0),
                              child: Text(
                                'You may also like',
                                style: MyTextStyle.mediumBold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, bottom: 80.0),
                        sliver: SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.85,
                            mainAxisSpacing: 10.0,
                            crossAxisSpacing: 10.0,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              Product product =
                                  _model.recommendedProductList[index];
                              return MyProductCard(product: product);
                            },
                            childCount: _model.recommendedProductList.length,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: MyColors.primary,
            label: const Text('Add to cart'),
            icon: const Icon(Icons.add_shopping_cart),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => ChangeNotifierProvider.value(
                  value: _model,
                  child: AddToCartSheet(product: _model.product),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

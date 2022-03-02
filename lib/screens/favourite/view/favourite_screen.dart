import 'package:ai_shopping_assistant/constants.dart';
import 'package:ai_shopping_assistant/model/cartProduct.dart';
import 'package:ai_shopping_assistant/model/favouriteProduct.dart';
import 'package:ai_shopping_assistant/model/product.dart';
import 'package:ai_shopping_assistant/screens/favourite/view_model/favourite_model.dart';
import 'package:ai_shopping_assistant/screens/search/view/search_screen.dart';
import 'package:ai_shopping_assistant/widgets/constants.dart';
import 'package:ai_shopping_assistant/widgets/myDrawer.dart';
import 'package:ai_shopping_assistant/widgets/myMainSliverAppBar.dart';
import 'package:ai_shopping_assistant/widgets/myProductCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavouriteScreen extends StatefulWidget {
  static const id = 'favourite_screen';
  const FavouriteScreen({Key? key}) : super(key: key);

  @override
  _FavouriteScreenState createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  late FavouriteModel _model;
  bool editMode = false;

  Widget _buildCartOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          child: Text(
            editMode ? 'Cancel' : 'Edit',
            style: MyTextStyle.small,
          ),
          onTap: () {
            setState(() {
              editMode = !editMode;
            });
          },
        ),
      ],
    );
  }

  Widget _buildFavouriteProduct(FavouriteProduct favouriteProduct) {
    return Container(
      height: 170.0,
      child: ListTile(
        contentPadding: const EdgeInsets.all(20.0),
        minVerticalPadding: 0,
        title: Row(
          children: [
            if (editMode)
              GestureDetector(
                child: const Icon(Icons.delete),
                onTap: () async {
                  await _model.removeFromFavourite(favouriteProduct);
                },
              ),
            Container(
              height: 130,
              width: 110,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(favouriteProduct.image),
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
                    favouriteProduct.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: MyTextStyle.small,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    'RM ${favouriteProduct.price.toStringAsFixed(2)}',
                    style: MyTextStyle.small,
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 10.0,
            ),
            Switch(
              value: favouriteProduct.notification,
              onChanged: (value) async {
                await _model.updateNotification(favouriteProduct, value);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(value
                          ? 'You will receive notificatiions about this product'
                          : 'You will not receive notifications about this product')),
                );
              },
              activeTrackColor: MyColors.primary,
              activeColor: Colors.lightBlue,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _model = FavouriteModel();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _model,
      child: Consumer<FavouriteModel>(
        builder: (context, model, child) => Scaffold(
          backgroundColor: Colors.white,
          drawer: MyDrawer(
            favouriteSelected: true,
          ),
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                MyMainSliverAppBar(),
                model.isLoading
                    ? SliverFillViewport(
                        delegate: SliverChildListDelegate([
                        const Center(
                          child: CircularProgressIndicator(),
                        )
                      ]))
                    : model.favouriteProductList.isEmpty
                        ? SliverFillViewport(
                            delegate: SliverChildListDelegate([
                            const Center(
                              child: Text('You have no products in favourite'),
                            )
                          ]))
                        : SliverList(
                            delegate: SliverChildListDelegate(
                              [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0, right: 20.0, top: 20.0),
                                  child: _buildCartOptions(),
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: model.favouriteProductList.length,
                                  itemBuilder: (context, index) {
                                    FavouriteProduct favouriteProduct =
                                        model.favouriteProductList[index];
                                    return _buildFavouriteProduct(
                                        favouriteProduct);
                                  },
                                ),
                                const Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      20.0, 20.0, 20.0, 15.0),
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
                        Product product = model.productList[index];
                        return MyProductCard(product: product);
                      },
                      childCount: model.productList.length,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

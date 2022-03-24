import 'package:ai_shopping_assistant/constants.dart';
import 'package:ai_shopping_assistant/model/cartProduct.dart';
import 'package:ai_shopping_assistant/screens/cart/view_model/cart_model.dart';
import 'package:ai_shopping_assistant/screens/checkout/view/checkout_screen.dart';
import 'package:ai_shopping_assistant/screens/product_details/view/product_details_screen.dart';
import 'package:ai_shopping_assistant/widgets/constants.dart';
import 'package:ai_shopping_assistant/widgets/myOutlinedButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  static const id = 'cart_screen';
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late CartModel _model;
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

  Widget _buildCartProduct(CartProduct cartProduct) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, ProductDetailsScreen.id,
            arguments:
                ProductDetailsScreenArguments(productId: cartProduct.id));
      },
      child: Container(
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
                    await _model.removeFromCart(cartProduct);
                  },
                ),
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
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      'RM ${cartProduct.price.toStringAsFixed(2)}',
                      style: MyTextStyle.small,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 10.0,
              ),
              Container(
                height: 30.0,
                width: 100.0,
                decoration: BoxDecoration(
                  color: MyColors.primary,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      child: const Icon(Icons.remove),
                      onTap: () {
                        if (cartProduct.quantity > 0) {
                          _model.changeProductQuantity(cartProduct, false);
                        }
                      },
                    ),
                    Text(cartProduct.quantity.toString(),
                        style: MyTextStyle.mediumSmall),
                    GestureDetector(
                      child: const Icon(Icons.add),
                      onTap: () {
                        _model.changeProductQuantity(cartProduct, true);
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubtotal(double subtotal) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          'Subtotal: RM ${subtotal.toStringAsFixed(2)}',
          style: MyTextStyle.mediumBold,
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _model = CartModel();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CartModel>(
      create: (context) => _model,
      child: Consumer<CartModel>(
        builder: (context, model, child) => Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: CustomScrollView(
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
                  title: const Text(
                    'Shopping cart',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                model.isLoading
                    ? SliverFillViewport(
                        delegate: SliverChildListDelegate([
                        const Center(
                          child: CircularProgressIndicator(),
                        )
                      ]))
                    : model.cartProductList.isEmpty
                        ? SliverFillViewport(
                            delegate: SliverChildListDelegate([
                            const Center(
                              child: Text('You have no products in cart'),
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
                                  itemCount: model.cartProductList.length,
                                  itemBuilder: (context, index) {
                                    CartProduct cartProduct =
                                        model.cartProductList[index];
                                    return _buildCartProduct(cartProduct);
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child:
                                      _buildSubtotal(model.calculateSubtotal()),
                                ),
                              ],
                            ),
                          ),
              ],
            ),
          ),
          bottomNavigationBar: model.cartProductList.isEmpty
              ? null
              : MyOutlinedButton(
                  text: 'Checkout',
                  onPressed: () {
                    Navigator.pushNamed(context, CheckoutScreen.id);
                  },
                ),
        ),
      ),
    );
  }
}

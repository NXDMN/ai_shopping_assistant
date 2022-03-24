import 'package:ai_shopping_assistant/constants.dart';
import 'package:ai_shopping_assistant/model/cartProduct.dart';
import 'package:ai_shopping_assistant/model/product.dart';
import 'package:ai_shopping_assistant/screens/cart/view/cart_screen.dart';
import 'package:ai_shopping_assistant/screens/product_details/view_model/product_details_model.dart';
import 'package:ai_shopping_assistant/widgets/constants.dart';
import 'package:ai_shopping_assistant/widgets/myOutlinedButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:loading_overlay/loading_overlay.dart';

class AddToCartSheet extends StatefulWidget {
  final Product product;

  AddToCartSheet({
    required this.product,
  });

  @override
  _AddToCartSheetState createState() => _AddToCartSheetState();
}

class _AddToCartSheetState extends State<AddToCartSheet> {
  Product get _product => widget.product;

  int count = 1;
  List<bool> selectedSize = [false, false, false, false, false];
  List<bool> selectedColor = [false, false, false, false, false, false];

  Widget _buildSizeOptions(String size) {
    return Container(
      height: 45.0,
      width: 45.0,
      color: Colors.grey[200],
      child: Center(
        child: Text(
          size,
          style: MyTextStyle.small,
        ),
      ),
    );
  }

  Widget _buildColorOptions(Color color) {
    return Container(
      height: 45.0,
      width: 45.0,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        color: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductDetailsModel>(
      builder: (context, model, child) {
        return model.isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  color: MyColors.shadow,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.network(
                                _product.images[0],
                                width: 90.0,
                                height: 90.0,
                              ),
                              Text(
                                'RM ${_product.price.toStringAsFixed(2)}',
                                style: MyTextStyle.mediumBold,
                              ),
                              Container(
                                height: 90.0,
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: GestureDetector(
                                    child: Icon(Icons.close),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const MyDivider(),
                        if (_product.category == "Fashion") ...[
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Size',
                                  style: MyTextStyle.mediumBold,
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                                ToggleButtons(
                                  renderBorder: false,
                                  fillColor: Colors.black,
                                  textStyle: const TextStyle(fontSize: 14),
                                  children: [
                                    _buildSizeOptions('XS'),
                                    _buildSizeOptions('S'),
                                    _buildSizeOptions('M'),
                                    _buildSizeOptions('L'),
                                    _buildSizeOptions('XL'),
                                  ],
                                  isSelected: selectedSize,
                                  onPressed: (int index) {
                                    setState(() {
                                      for (int buttonIndex = 0;
                                          buttonIndex < selectedSize.length;
                                          buttonIndex++) {
                                        if (buttonIndex == index) {
                                          selectedSize[buttonIndex] = true;
                                        } else {
                                          selectedSize[buttonIndex] = false;
                                        }
                                      }
                                    });
                                  },
                                )
                              ],
                            ),
                          ),
                          const MyDivider(),
                        ],
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Color',
                                style: MyTextStyle.mediumBold,
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              ToggleButtons(
                                renderBorder: false,
                                fillColor: MyColors.primary,
                                children: [
                                  _buildColorOptions(Colors.black),
                                  _buildColorOptions(Colors.white),
                                  _buildColorOptions(Colors.red),
                                  _buildColorOptions(Colors.blue),
                                  _buildColorOptions(Colors.yellow),
                                  _buildColorOptions(Colors.green),
                                ],
                                isSelected: selectedColor,
                                onPressed: (int index) {
                                  setState(() {
                                    for (int buttonIndex = 0;
                                        buttonIndex < selectedColor.length;
                                        buttonIndex++) {
                                      if (buttonIndex == index) {
                                        selectedColor[buttonIndex] = true;
                                      } else {
                                        selectedColor[buttonIndex] = false;
                                      }
                                    }
                                  });
                                },
                              )
                            ],
                          ),
                        ),
                        const MyDivider(),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Quantity',
                                style: MyTextStyle.mediumBold,
                              ),
                              Container(
                                height: 30.0,
                                width: 100.0,
                                decoration: BoxDecoration(
                                  color: MyColors.primary,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    GestureDetector(
                                      child: Icon(Icons.remove),
                                      onTap: () {
                                        if (count > 0) {
                                          setState(() {
                                            count--;
                                          });
                                        }
                                      },
                                    ),
                                    Text(count.toString(),
                                        style: MyTextStyle.mediumSmall),
                                    GestureDetector(
                                      child: Icon(Icons.add),
                                      onTap: () {
                                        setState(() {
                                          count++;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        MyOutlinedButton(
                          text: 'Add',
                          onPressed: () async {
                            CartProduct cartProduct = CartProduct(
                              id: _product.id,
                              name: _product.name,
                              image: _product.images[0],
                              price: _product.price,
                              quantity: count,
                            );
                            await model.addToCart(cartProduct);
                            Navigator.pushNamed(context, CartScreen.id);
                          },
                        )
                      ],
                    ),
                  ),
                ),
              );
      },
    );
  }
}

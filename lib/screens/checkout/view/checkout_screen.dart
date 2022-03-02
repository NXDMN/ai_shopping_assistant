import 'package:ai_shopping_assistant/constants.dart';
import 'package:ai_shopping_assistant/model/cartProduct.dart';
import 'package:ai_shopping_assistant/screens/checkout/view_model/checkout_model.dart';
import 'package:ai_shopping_assistant/widgets/constants.dart';
import 'package:ai_shopping_assistant/widgets/myCalculationList.dart';
import 'package:ai_shopping_assistant/widgets/myDialog.dart';
import 'package:ai_shopping_assistant/widgets/myOutlinedButton.dart';
import 'package:ai_shopping_assistant/widgets/myProductListTile.dart';
import 'package:ai_shopping_assistant/widgets/myUnderlineTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum PaymentOptions { online, card }

class CheckoutScreen extends StatefulWidget {
  static const id = 'checkout_screen';
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late CheckoutModel _model;
  String address = "";
  PaymentOptions? _paymentOptions;

  Widget _buildPaymentOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment options',
          style: MyTextStyle.mediumBold,
        ),
        const SizedBox(
          height: 15.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                title: const Text(
                  'Online Banking',
                  style: MyTextStyle.small,
                ),
                leading: Radio<PaymentOptions>(
                  activeColor: MyColors.primary,
                  value: PaymentOptions.online,
                  groupValue: _paymentOptions,
                  onChanged: (PaymentOptions? value) {
                    setState(() {
                      _paymentOptions = value;
                    });
                  },
                ),
              ),
            ),
            Expanded(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                title: const Text(
                  'Debit/Credit Card',
                  style: MyTextStyle.small,
                ),
                leading: Radio<PaymentOptions>(
                  activeColor: MyColors.primary,
                  value: PaymentOptions.card,
                  groupValue: _paymentOptions,
                  onChanged: (PaymentOptions? value) {
                    setState(() {
                      _paymentOptions = value;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _model = CheckoutModel();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CheckoutModel>(
      create: (context) => _model,
      child: Consumer<CheckoutModel>(
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
                    'Checkout',
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
                    : SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Delivery address',
                                    style: MyTextStyle.mediumBold,
                                  ),
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                  ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Wrap(
                                      children: [
                                        Text(
                                          model.address == ""
                                              ? 'Please input your address'
                                              : model.address,
                                          style: model.address == ""
                                              ? const TextStyle(
                                                  color: Colors.grey)
                                              : MyTextStyle.mediumSmall,
                                        ),
                                      ],
                                    ),
                                    trailing: GestureDetector(
                                      child: const Icon(Icons.edit),
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return MyDialog(
                                                children: [
                                                  MyUnderlineTextFormField(
                                                    text: 'Enter address',
                                                    onChanged: (value) {
                                                      address = value;
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                  MyOutlinedButton(
                                                    text: 'Confirm',
                                                    onPressed: () {
                                                      model.updateAddress(
                                                          address);
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const MyDivider(),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: _buildPaymentOptions(),
                            ),
                            const MyDivider(),
                            const Padding(
                              padding: EdgeInsets.only(
                                left: 20.0,
                                right: 20.0,
                                top: 20.0,
                              ),
                              child: Text(
                                'Products',
                                style: MyTextStyle.mediumBold,
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: model.cartProductList.length,
                              itemBuilder: (context, index) {
                                CartProduct cartProduct =
                                    model.cartProductList[index];
                                return MyProductListTile(
                                    cartProduct: cartProduct);
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: MyCalculationList(
                                subtotal: _model.subtotal,
                                deliveryFee: _model.deliveryFee,
                                total: _model.total,
                              ),
                            ),
                            MyOutlinedButton(
                              text: 'Pay',
                              onPressed: () async {
                                if (model.address == "") {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text("Please enter your address"),
                                    ),
                                  );
                                } else if (_paymentOptions == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          "Please choose your payment option"),
                                    ),
                                  );
                                } else {
                                  if (await model.makePayment()) {
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(model.errorMessage)),
                                    );
                                  }
                                }
                              },
                            ),
                          ],
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

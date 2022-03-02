import 'package:ai_shopping_assistant/constants.dart';
import 'package:ai_shopping_assistant/model/cartProduct.dart';
import 'package:ai_shopping_assistant/model/purchaseHistory.dart';
import 'package:ai_shopping_assistant/screens/purchase_history/view_model/purchase_history_model.dart';
import 'package:ai_shopping_assistant/widgets/constants.dart';
import 'package:ai_shopping_assistant/widgets/myCalculationList.dart';
import 'package:ai_shopping_assistant/widgets/myProductListTile.dart';
import 'package:flutter/material.dart';

class PurchaseHistoryDetailsScreenArguments {
  final PurchaseHistory purchaseHistory;

  PurchaseHistoryDetailsScreenArguments({required this.purchaseHistory});
}

class PurchaseHistoryDetailsScreen extends StatefulWidget {
  static const id = 'purchase_history_details_screen';
  final PurchaseHistoryDetailsScreenArguments args;

  PurchaseHistoryDetailsScreen({required this.args});

  @override
  _PurchaseHistoryDetailsScreenState createState() =>
      _PurchaseHistoryDetailsScreenState();
}

class _PurchaseHistoryDetailsScreenState
    extends State<PurchaseHistoryDetailsScreen> {
  PurchaseHistory get _purchaseHistory => widget.args.purchaseHistory;
  late PurchaseHistoryModel _model;

  @override
  void initState() {
    super.initState();
    _model = PurchaseHistoryModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              title: Text(
                'Date: ${_purchaseHistory.date}',
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            SliverList(
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
                                _purchaseHistory.address,
                                style: MyTextStyle.mediumSmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
                    itemCount: _purchaseHistory.products.length,
                    itemBuilder: (context, index) {
                      CartProduct cartProduct =
                          _purchaseHistory.products[index];
                      return MyProductListTile(cartProduct: cartProduct);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: MyCalculationList(
                      subtotal:
                          _model.calculateSubtotal(_purchaseHistory.products),
                      deliveryFee: 10.00,
                      total: _purchaseHistory.total,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

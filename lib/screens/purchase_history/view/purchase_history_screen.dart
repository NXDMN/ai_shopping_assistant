import 'package:ai_shopping_assistant/constants.dart';
import 'package:ai_shopping_assistant/model/cartProduct.dart';
import 'package:ai_shopping_assistant/model/purchaseHistory.dart';
import 'package:ai_shopping_assistant/screens/purchase_history/view/purchase_history_details.screen.dart';
import 'package:ai_shopping_assistant/screens/purchase_history/view_model/purchase_history_model.dart';
import 'package:ai_shopping_assistant/widgets/constants.dart';
import 'package:ai_shopping_assistant/widgets/myDrawer.dart';
import 'package:ai_shopping_assistant/widgets/myMainSliverAppBar.dart';
import 'package:ai_shopping_assistant/widgets/myProductListTile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PurchaseHistoryScreen extends StatefulWidget {
  static const id = 'purchase_history_screen';
  const PurchaseHistoryScreen({Key? key}) : super(key: key);

  @override
  _PurchaseHistoryScreenState createState() => _PurchaseHistoryScreenState();
}

class _PurchaseHistoryScreenState extends State<PurchaseHistoryScreen> {
  Widget _buildHistory(PurchaseHistory purchaseHistory) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          PurchaseHistoryDetailsScreen.id,
          arguments: PurchaseHistoryDetailsScreenArguments(
              purchaseHistory: purchaseHistory),
        );
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 20.0,
              right: 20.0,
              top: 20.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Date: ${purchaseHistory.date}',
                  style: MyTextStyle.mediumSmall,
                ),
                Text(
                  'Total: RM ${purchaseHistory.total.toStringAsFixed(2)}',
                  style: MyTextStyle.mediumSmall,
                ),
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: purchaseHistory.products.length,
            itemBuilder: (context, index) {
              CartProduct cartProduct = purchaseHistory.products[index];
              return MyProductListTile(cartProduct: cartProduct);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PurchaseHistoryModel(),
      child: Consumer<PurchaseHistoryModel>(
        builder: (context, model, child) => Scaffold(
          backgroundColor: Colors.white,
          drawer: MyDrawer(
            historySelected: true,
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
                    : SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            const Padding(
                              padding:
                                  EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 15.0),
                              child: Text(
                                'Purchase history',
                                style: MyTextStyle.mediumBold,
                              ),
                            ),
                            const MyDivider(),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: model.purchaseHistoryList.length,
                              itemBuilder: (context, index) {
                                PurchaseHistory purchaseHistory =
                                    model.purchaseHistoryList[index];
                                return _buildHistory(purchaseHistory);
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

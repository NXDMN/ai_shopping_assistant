import 'package:ai_shopping_assistant/constants.dart';
import 'package:ai_shopping_assistant/widgets/constants.dart';
import 'package:ai_shopping_assistant/widgets/myOutlinedButton.dart';
import 'package:flutter/material.dart';

enum PaymentOptions { online, card }

class CheckoutScreen extends StatefulWidget {
  static const id = 'checkout_screen';
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  PaymentOptions? _paymentOptions;

  Widget _buildPaymentOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment options',
          style: MyTextStyle.mediumBold,
        ),
        SizedBox(
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

  List<Widget> _buildCartProduct() {
    return [
      Container(
        height: 170.0,
        child: ListTile(
          contentPadding: EdgeInsets.all(20.0),
          minVerticalPadding: 0,
          title: Row(
            children: [
              Container(
                height: 130,
                width: 110,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/Men Clothes.jpg'),
                  ),
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Wow new shirt'),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text('x 1'),
                  ],
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Text('RM 300.00'),
            ],
          ),
        ),
      ),
      const MyDivider(),
    ];
  }

  Widget _buildCalculations() {
    return Column(
      children: [
        ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          title: Text(
            'Subtotal',
            style: MyTextStyle.mediumBold,
          ),
          trailing: Container(
            width: 100.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'RM',
                  style: MyTextStyle.mediumSmall,
                ),
                Text(
                  '300.00',
                  style: MyTextStyle.mediumSmall,
                ),
              ],
            ),
          ),
        ),
        ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          title: Text(
            'Delivery fee',
            style: MyTextStyle.mediumBold,
          ),
          trailing: Container(
            width: 100.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'RM',
                  style: MyTextStyle.mediumSmall,
                ),
                Text(
                  '10.00',
                  style: MyTextStyle.mediumSmall,
                ),
              ],
            ),
          ),
        ),
        ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          title: Text(
            'Total',
            style: MyTextStyle.mediumBold,
          ),
          trailing: Container(
            width: 100.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'RM',
                  style: MyTextStyle.mediumSmall,
                ),
                Text(
                  '300.00',
                  style: MyTextStyle.mediumSmall,
                ),
              ],
            ),
          ),
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
              title: Text(
                'Checkout',
                style: TextStyle(
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
                        Text(
                          'Delivery address',
                          style: MyTextStyle.mediumBold,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Wrap(
                            children: [
                              Text(
                                '479, Jalan Seri 26, Taman Sri Bakri 3, Jalan Bakri, 84000 Muar, Johor',
                                style: MyTextStyle.mediumSmall,
                              ),
                            ],
                          ),
                          trailing: GestureDetector(
                            child: Icon(Icons.arrow_forward),
                            onTap: () {},
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
                  ..._buildCartProduct(),
                  ..._buildCartProduct(),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: _buildCalculations(),
                  ),
                  MyOutlinedButton(
                    text: 'Pay',
                    onPressed: () {},
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

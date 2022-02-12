import 'package:ai_shopping_assistant/constants.dart';
import 'package:ai_shopping_assistant/screens/checkout_screen.dart';
import 'package:ai_shopping_assistant/widgets/constants.dart';
import 'package:ai_shopping_assistant/widgets/myOutlinedButton.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  static const id = 'cart_screen';
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int count = 0;

  Widget _buildCartOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          child: const Text(
            'Edit',
            style: MyTextStyle.small,
          ),
          onTap: () {},
        ),
        GestureDetector(
          child: const Text(
            'Select all',
            style: MyTextStyle.small,
          ),
          onTap: () {},
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
                    Text('RM 300.00'),
                  ],
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Container(
                height: 30.0,
                width: 100.0,
                decoration: BoxDecoration(
                  color: Color(0xff81D3F8),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                    Text(count.toString(), style: MyTextStyle.mediumSmall),
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
      ),
      const MyDivider(),
    ];
  }

  Widget _buildSubtotal() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          'Subtotal: RM 600.00',
          style: MyTextStyle.mediumBold,
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
                'Shopping cart',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 20.0),
                    child: _buildCartOptions(),
                  ),
                  ..._buildCartProduct(),
                  ..._buildCartProduct(),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: _buildSubtotal(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: MyOutlinedButton(
        text: 'Checkout',
        onPressed: () {
          Navigator.pushNamed(context, CheckoutScreen.id);
        },
      ),
    );
  }
}

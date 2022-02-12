import 'package:ai_shopping_assistant/constants.dart';
import 'package:ai_shopping_assistant/widgets/constants.dart';
import 'package:ai_shopping_assistant/widgets/myOutlinedButton.dart';
import 'package:flutter/material.dart';

class AddToCartSheet extends StatefulWidget {
  const AddToCartSheet({Key? key}) : super(key: key);

  @override
  _AddToCartSheetState createState() => _AddToCartSheetState();
}

class _AddToCartSheetState extends State<AddToCartSheet> {
  int count = 1;

  Widget _buildSizeOptions(String size) {
    return Container(
      height: 50.0,
      width: 50.0,
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
      height: 50.0,
      width: 50.0,
      decoration: BoxDecoration(
        border: Border.all(),
        color: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        color: Color(0xff757575),
        child: Container(
          decoration: BoxDecoration(
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
                    Image.asset(
                      'assets/images/Men Clothes.jpg',
                      width: 90.0,
                      height: 90.0,
                    ),
                    Text(
                      'RM 300.00',
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildSizeOptions('XS'),
                        _buildSizeOptions('S'),
                        _buildSizeOptions('M'),
                        _buildSizeOptions('L'),
                        _buildSizeOptions('XL'),
                      ],
                    )
                  ],
                ),
              ),
              const MyDivider(),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildColorOptions(Colors.black),
                        _buildColorOptions(Colors.white),
                        _buildColorOptions(Colors.red),
                        _buildColorOptions(Colors.blue),
                        _buildColorOptions(Colors.yellow),
                        _buildColorOptions(Colors.green),
                      ],
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
                onPressed: () {},
              )
            ],
          ),
        ),
      ),
    );
  }
}

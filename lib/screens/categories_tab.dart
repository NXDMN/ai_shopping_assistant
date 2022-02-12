import 'package:flutter/material.dart';
import 'package:ai_shopping_assistant/widgets/constants.dart';

class CategoriesTab extends StatefulWidget {
  const CategoriesTab({Key? key}) : super(key: key);

  @override
  _CategoriesTabState createState() => _CategoriesTabState();
}

class _CategoriesTabState extends State<CategoriesTab> {
  List<String> categoriesList = [
    'Health & Beauty',
    'Baby & Toys',
    'Home & Living',
    'Shoes',
    'Home Appliances',
    'Mobile & Accessories',
    'Women Clothes',
    'Men Clothes',
    'Watches',
    'Bags & Wallets'
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: categoriesList.length,
      separatorBuilder: (context, index) => const MyDivider(),
      itemBuilder: (context, index) {
        String category = categoriesList[index];
        return Container(
          height: 100.0,
          child: ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(category),
                Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/banner1.jpg'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

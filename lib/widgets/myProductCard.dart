import 'package:flutter/material.dart';

class MyProductCard extends StatelessWidget {
  const MyProductCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Container(
        height: 200.0,
        width: 180.0,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              height: 130,
              width: 110,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage('assets/images/Men Clothes.jpg'))),
            ),
            Text('RM30'),
            Text('Shirt'),
          ],
        ),
      ),
    );
  }
}

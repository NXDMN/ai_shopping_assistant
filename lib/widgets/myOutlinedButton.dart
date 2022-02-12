import 'package:flutter/material.dart';
import 'package:ai_shopping_assistant/constants.dart';

class MyOutlinedButton extends StatelessWidget {
  MyOutlinedButton({
    required this.text,
    this.onPressed,
  });

  final String text;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      child: OutlinedButton(
        child: Text(
          text,
          style: MyTextStyle.small,
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>((states) =>
              states.contains(MaterialState.pressed)
                  ? MyColors.primary
                  : Colors.white),
          shape: MaterialStateProperty.all<OutlinedBorder>(
              const BeveledRectangleBorder()),
          side: MaterialStateProperty.resolveWith<BorderSide>(
              (Set<MaterialState> states) => BorderSide(
                  color: states.contains(MaterialState.pressed)
                      ? MyColors.primary
                      : Colors.grey,
                  width: 1)),
        ),
        onPressed: onPressed,
      ),
    );
  }
}

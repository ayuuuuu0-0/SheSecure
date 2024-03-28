import 'package:flutter/material.dart';

class RectangularButton extends StatelessWidget {
  final String? text;
  final VoidCallback press;
  final textColor;

  RectangularButton({
    required this.text,
    required this.press,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical:10,horizontal: 10),
      width: size.width * 0.85,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF8C90A6),
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            ),
            onPressed: press,
            child: Text(
              text!,
              style: TextStyle(
                color: textColor,
                fontSize: 25.0,
                fontFamily: 'Poppins Regular',
              ),
            ),
          )
      ),
    );
  }
}

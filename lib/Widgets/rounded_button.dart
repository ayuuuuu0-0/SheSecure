import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String? text;
  final VoidCallback press;
  final Color color, textColor;

  RoundedButton({
    required this.text,
    required this.press,
    this.color = Colors.black54,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.black26, offset: Offset(0, 4), blurRadius: 5.0)
        ],
        // gradient: LinearGradient(
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        //   stops: [0.0, 1.0],
        //   colors: [
        //     Colors.blueAccent.shade400,
        //     Colors.deepPurple.shade400,
        //   ],
        // ),
        color: Colors.black,
        borderRadius: BorderRadius.circular(40),
      ),
      margin: const EdgeInsets.symmetric(vertical: 1),
      width: size.width * 0.7,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            ),
            onPressed: press,
            child: Text(
              text!,
              style: TextStyle(
                  color: textColor,
                  fontSize: 24.0,
                  fontFamily: 'Poppins Regular'),
            ),
          )),
    );
  }
}

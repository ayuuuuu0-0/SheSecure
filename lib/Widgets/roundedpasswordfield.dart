import 'package:flutter/material.dart';
import '../Widgets/text_field_container.dart';

class RoundedPasswordField extends StatefulWidget {

  final ValueChanged<String> onChanged;

  RoundedPasswordField({
    required this.onChanged,
  });

  @override
  State<RoundedPasswordField> createState() => _RoundedPasswordFieldState();
}

bool obscureText = true;

class _RoundedPasswordFieldState extends State<RoundedPasswordField> {
  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        obscureText: obscureText,
        onChanged: widget.onChanged,
        cursorColor: Colors.indigoAccent,
        decoration: InputDecoration(
          hintText: 'Password',
          prefixIcon: Icon(
            Icons.lock,
            color: Colors.indigoAccent,
          ),
          suffixIcon: GestureDetector(
            onTap: (){
              setState(() {
                obscureText = !obscureText;
              });
            },
            child: Icon(
              obscureText
                  ? Icons.visibility_off
                  :Icons.visibility,
              color: Colors.black54,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            borderSide: BorderSide(
              width: 1, color: Color(0xFF441256),
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            borderSide: BorderSide(
                width: 1, color: Colors.grey
            ),
          ),
        ),
      ),
    );
  }
}

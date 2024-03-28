import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:she_secure/HomeScreen/homeScreen.dart';
import 'package:she_secure/LoginScreen/loginbackground.dart';
import '../SignupScreen/signup_screen.dart';
import '../Widgets/ErrorAlertDialog.dart';
import '../Widgets/alreadyhaveaccount.dart';
import '../Widgets/loading_dialog.dart';
import '../Widgets/rounded_button.dart';
import '../Widgets/rounded_input_field.dart';
import '../Widgets/roundedpasswordfield.dart';
import '../forgot password/forgotpassword.dart';

class LoginBody extends StatefulWidget {
  const LoginBody({super.key});

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _login() async {
    showDialog(
        context: context,
        builder: (_) {
          return LoadingAlertDialog(
            message: 'Please wait',
          );
        });

    User? currentUser;
    await _auth
        .signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    )
        .then((auth) {
      currentUser = auth.user;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) {
            return ErrorAlertDialog(Message: error.message.toString());
          });
    });
    if (currentUser != null) {
      //ignore: use_build_context_synchronously
      Navigator.pop(context);
      //ignore: use_build_Context_synchronously
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      print('error');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return LoginBackground(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: size.height * 0.04,
            ),
            Image.asset(
              'assets/images/login.png',
              height: size.height * 0.35,
            ),
            SizedBox(
              height: size.height * 0.0005,
            ),
            RoundedInputField(
              hintText: 'Email',
              icon: Icons.person,
              onChanged: (value) {
                _emailController.text = value;
              },
            ),
            const SizedBox(
              height: 6,
            ),
            RoundedPasswordField(
              onChanged: (value) {
                _passwordController.text = value;
              },
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ForgotPassword()));
                },
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
            RoundedButton(
              text: 'LOGIN',
              press: () {
                _emailController.text.isNotEmpty &&
                        _passwordController.text.isNotEmpty
                    ? _login()
                    : showDialog(
                        context: context,
                        builder: (context) {
                          return ErrorAlertDialog(
                              Message:
                                  'Please write email & password for Login');
                        });
              },
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            AlreadyHaveAnAccount(
              login: true,
              press: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignUpScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}

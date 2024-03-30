import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:she_secure/HomeScreen/homeScreen.dart';
import 'package:she_secure/SignupScreen/signup_screen.dart';
import 'package:she_secure/SignupScreen/signupbackground.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:she_secure/mainTabView.dart';
import '../LoginScreen/login_screen.dart';
import '../Widgets/ErrorAlertDialog.dart';
import '../Widgets/alreadyhaveaccount.dart';
import '../Widgets/global_var.dart';
import '../Widgets/rounded_button.dart';
import '../Widgets/rounded_input_field.dart';
import '../Widgets/roundedpasswordfield.dart';
import '../forgot password/forgotpassword.dart';
import 'dart:io';

class SignUpBody extends StatefulWidget {
  const SignUpBody({Key? key}) : super(key: key);

  @override
  State<SignUpBody> createState() => _SignUpBodyState();
}

class _SignUpBodyState extends State<SignUpBody> {
  String userPhotoUrl = '';
  File? _image;
  bool _isLoading = false;

  final signUpFormKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emergency1Controller = TextEditingController();
  final TextEditingController _emergency2Controller = TextEditingController();
  final TextEditingController _emergency3Controller = TextEditingController();
  final TextEditingController _emergency4Controller = TextEditingController();
  final TextEditingController _emergencyName1Controller =
      TextEditingController();
  final TextEditingController _emergencyName2Controller =
      TextEditingController();
  final TextEditingController _emergencyName3Controller =
      TextEditingController();
  final TextEditingController _emergencyName4Controller =
      TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _getFromCamera() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }

  void _getFromGallery() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }

  void _cropImage(filePath) async {
    try {
      if (filePath != null) {
        CroppedFile? croppedImage = await ImageCropper().cropImage(
          sourcePath: filePath,
          maxHeight: 1080,
          maxWidth: 1080,
        );

        if (croppedImage != null) {
          setState(() {
            _image = File(croppedImage.path);
          });
        }
      }
    } catch (e) {
      print('Error cropping image: $e');
    }
  }

  void _showImageDisplay() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Please choose an option'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    _getFromCamera();
                  },
                  child: const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.camera,
                          color: Colors.purple,
                        ),
                      ),
                      Text(
                        'Camera',
                        style: TextStyle(color: Colors.purple),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    _getFromGallery();
                  },
                  child: const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.image,
                          color: Colors.purple,
                        ),
                      ),
                      Text(
                        'Gallery',
                        style: TextStyle(color: Colors.purple),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  void submitFormOnSignup() async {
    final isValid = signUpFormKey.currentState!.validate();
    if (isValid) {
      if (_image == null) {
        showDialog(
            context: context,
            builder: (context) {
              return ErrorAlertDialog(
                Message: 'Please pick an image',
              );
            });
        return;
      }
      setState(() {
        _isLoading = true;
      });
      try {
        await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim().toLowerCase(),
          password: _passwordController.text.trim(),
        );

        final User? user = _auth.currentUser;
        uid = user!.uid;

        final ref = FirebaseStorage.instance
            .ref()
            .child('userImages')
            .child(uid + '.jpg');
        await ref.putFile(_image!);
        userPhotoUrl = await ref.getDownloadURL();
        FirebaseFirestore.instance.collection('users').doc(uid).set({
          'userName': _nameController.text.trim(),
          'id': uid,
          'userNumber': _phoneController.text.trim(),
          'emergencyName1': _emergencyName1Controller.text.trim(),
          'emergencyContact1': _emergency1Controller.text.trim(),
          'emergencyName2': _emergencyName2Controller.text.trim(),
          'emergencyContact2': _emergency2Controller.text.trim(),
          'emergencyName3': _emergencyName3Controller.text.trim(),
          'emergencyContact3': _emergency3Controller.text.trim(),
          'emergencyName4': _emergencyName4Controller.text.trim(),
          'emergencyContact4': _emergency4Controller.text.trim(),
          'userEmail': _emailController.text,
          'userImage': userPhotoUrl,
          'time': DateTime.now(),
          'status': 'approved',
        });
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainTabView()));
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        ErrorAlertDialog(
          Message: error.toString(),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width,
        screenHeight = MediaQuery.of(context).size.height;
    return SignUpBackground(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sign-Up',
              style: TextStyle(fontFamily: 'Poppins SemiBold', fontSize: 40),
            ),
            SizedBox(
              height: screenHeight * 0.01,
            ),
            Form(
              key: signUpFormKey,
              child: InkWell(
                onTap: () {
                  _showImageDisplay();
                },
                child: CircleAvatar(
                  radius: screenWidth * 0.20,
                  backgroundColor: Colors.black54,
                  backgroundImage: _image == null ? null : FileImage(_image!),
                  child: _image == null
                      ? Icon(
                          Icons.camera_enhance,
                          size: screenWidth * 0.180,
                          color: Colors.black54,
                        )
                      : null,
                ),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.002,
            ),
            //Image.asset('assets/images/login.png'),
            RoundedInputField(
              hintText: 'Name',
              icon: Icons.person,
              onChanged: (value) {
                _nameController.text = value;
              },
            ),
            RoundedInputField(
              hintText: 'Email',
              icon: Icons.email,
              onChanged: (value) {
                _emailController.text = value;
              },
            ),
            RoundedInputField(
              hintText: 'Phone',
              icon: Icons.call,
              onChanged: (value) {
                _phoneController.text = value;
              },
            ),
            RoundedInputField(
              hintText: 'Emergency Contact Name',
              icon: Icons.call,
              onChanged: (value) {
                _emergencyName1Controller.text = value;
              },
            ),
            RoundedInputField(
              hintText: 'Emergency Contact No 1',
              icon: Icons.call,
              onChanged: (value) {
                _emergency1Controller.text = value;
              },
            ),
            RoundedInputField(
              hintText: 'Emergency Contact Name',
              icon: Icons.call,
              onChanged: (value) {
                _emergencyName2Controller.text = value;
              },
            ),
            RoundedInputField(
              hintText: 'Emergency Contact No 2',
              icon: Icons.call,
              onChanged: (value) {
                _emergency2Controller.text = value;
              },
            ),
            RoundedInputField(
              hintText: 'Emergency Contact Name',
              icon: Icons.call,
              onChanged: (value) {
                _emergencyName3Controller.text = value;
              },
            ),
            RoundedInputField(
              hintText: 'Emergency Contact No 3',
              icon: Icons.call,
              onChanged: (value) {
                _emergency3Controller.text = value;
              },
            ),
            RoundedInputField(
              hintText: 'Emergency Contact Name',
              icon: Icons.call,
              onChanged: (value) {
                _emergencyName4Controller.text = value;
              },
            ),
            RoundedInputField(
              hintText: 'Emergency Contact No 4',
              icon: Icons.call,
              onChanged: (value) {
                _emergency4Controller.text = value;
              },
            ),
            RoundedPasswordField(
              onChanged: (value) {
                _passwordController.text = value;
              },
            ),
            //const SizedBox(height: 0.1,),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ForgotPassword()));
                },
                child: Text(
                  'Forget Password?',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
            _isLoading
                ? Center(
                    child: Container(
                      width: 70,
                      height: 70,
                      child: const CircularProgressIndicator(),
                    ),
                  )
                : RoundedButton(
                    text: 'SIGN UP',
                    press: () {
                      submitFormOnSignup();
                    },
                  ),
            SizedBox(
              height: screenHeight * 0.02,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(40, 10, 40, 0),
              child: Row(
                children: [
                  Expanded(
                      child: Container(
                    height: 1,
                    color: Color(0xff786F72).withOpacity(0.5),
                  )),
                  Text(
                    "  Or  ",
                    style: TextStyle(color: Color(0xff1D1617), fontSize: 12),
                  ),
                  Expanded(
                      child: Container(
                    height: 1,
                    color: Color(0xff786F72).withOpacity(0.5),
                  )),
                ],
              ),
            ),
            SizedBox(
              height: screenWidth * 0.04,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 50,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        width: 1,
                        color: Color(0xff786F72).withOpacity(0.4),
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Image.asset(
                      "assets/images/google.png",
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),
                SizedBox(
                  width: screenWidth * 0.04,
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 50,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        width: 1,
                        color: Color(0xff786F72).withOpacity(0.4),
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Image.asset(
                      "assets/images/facebook.png",
                      width: 20,
                      height: 20,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: screenHeight * 0.03,
            ),
            AlreadyHaveAnAccount(
              login: false,
              press: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}

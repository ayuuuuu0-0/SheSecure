import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:she_secure/Widgets/global_var.dart';
import 'package:she_secure/mainTabView.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  String userEmergencyPhotoUrl = '';
  File? _image;

  FirebaseAuth _auth = FirebaseAuth.instance;

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
    CroppedFile? croppedImage = await ImageCropper()
        .cropImage(sourcePath: filePath, maxHeight: 1080, maxWidth: 1080);

    if (croppedImage != null) {
      setState(() {
        _image = File(croppedImage.path);
      });
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

  _buildUserImage() {
    return Container(
      width: 50,
      height: 40,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: NetworkImage(
              userImageUrl,
            ),
            fit: BoxFit.fill,
          )),
    );
  }

  getMyData() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((results) {
      setState(() {
        userImageUrl = results.data()!['userImage'];
        getUserName = results.data()!['userName'];
      });
    });
  }

  void _onImageSubmit() async {
    final User? user = _auth.currentUser;
    uid = user!.uid;
    final ref =
        FirebaseStorage.instance.ref().child('images').child(uid + '.jpg');
    await ref.putFile(_image!);
    userEmergencyPhotoUrl = await ref.getDownloadURL();
    FirebaseFirestore.instance.collection('EmergencyImage').doc(uid).set({
      'userEmergencyImage': userEmergencyPhotoUrl,
    });
  }

  void _sos() async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd-MM-yyyy – kk:mm').format(now);

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.fromLTRB(40, 80, 40, 80),
          content: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 1,
              child: Column(
                children: <Widget>[
                  Text(
                    'Emergency Alert!',
                    style: TextStyle(
                        // fontFamily: 'Montserrat',
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF7373)),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Detail Info',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      //color: Color(0xFFFF7373)
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                    thickness: 0.5,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        ' Name',
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold),
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          getUserName,
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w900),
                        )),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        ' Date & Time',
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold),
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          formattedDate,
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w900),
                        )),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        ' City',
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold),
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${place.locality}',
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w900),
                        )),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        ' State',
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold),
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${place.administrativeArea}',
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w900),
                        )),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        ' Pincode',
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold),
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${place.postalCode}',
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w900),
                        )),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFFFF7373),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      _onImageSubmit();
                      _confirmation();
                    },
                    child: const Text(
                      'Send Alert ',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      side:
                          const BorderSide(color: Color(0XFFFF7373), width: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MainTabView()));

                      Navigator.pop(context);
                    },
                    child: const Text('Ignore',
                        style: TextStyle(color: Color(0XFFFF7373))),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _confirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.fromLTRB(40, 230, 40, 230),
          content: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 1,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'All details sent',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.green.shade300,
                    child: CircleAvatar(
                      radius: 65,
                      backgroundColor: Colors.green,
                      child: Icon(
                        Icons.check,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      side:
                          const BorderSide(color: Color(0XFFFF7373), width: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('OK',
                        style: TextStyle(color: Color(0XFFFF7373))),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    uid = FirebaseAuth.instance.currentUser!.uid;
    userEmail = FirebaseAuth.instance.currentUser!.email!;
    getMyData();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width,
        screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 10),
            decoration: const BoxDecoration(
              color: Color(0XFFFF7373),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              automaticallyImplyLeading: false,
              leading: IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return MainTabView();
                  }));
                },
                icon: const Icon(
                  Icons.arrow_back_ios_new_sharp,
                  color: Colors.white,
                ),
              ),
              title: const Center(
                  child: Text(
                'Emergency Picture',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                  fontSize: 23,
                  shadows: [
                    Shadow(
                      // bottomLeft

                      offset: Offset(-0.25, -0.25),
                      color: Colors.black87,
                    ),
                    Shadow(
                      // bottomRight

                      offset: Offset(0.25, -0.25),
                      color: Colors.black87,
                    ),
                    Shadow(
                      // topRight
                      blurRadius: 10,
                      offset: Offset(0.25, 0.25),
                      color: Colors.black87,
                    ),
                    Shadow(
                      // topLeft
                      blurRadius: 10,
                      offset: Offset(-0.25, 0.25),
                      color: Colors.black87,
                    ),
                  ],
                ),
              )),
              actions: [
                _buildUserImage(),
              ],
            ),
          ),
          const Card(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 10, 0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Send Emergency Alert with picture',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 10, 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Upload image below and get started!',
                      style: TextStyle(
                          color: Color(0XFFFF7373),
                          fontSize: 16,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Container(
              child: Center(
                child: InkWell(
                  onTap: () {
                    _showImageDisplay();
                  },
                  child: Container(
                    width: screenWidth * 0.80,
                    height: screenWidth * 0.80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black45,
                      image: _image == null
                          ? null
                          : DecorationImage(
                              image: FileImage(_image!),
                              fit: BoxFit.cover,
                            ),
                    ),
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
            ),
          ),
          // Container(
          //   child: Center(
          //     child: InkWell(
          //       onTap: () {
          //         _showImageDisplay();
          //       },
          //       child: CircleAvatar(
          //         radius: screenWidth * 0.20,
          //         backgroundColor: Colors.black45,
          //         backgroundImage: _image == null ? null : FileImage(_image!),
          //         child: _image == null
          //             ? Icon(
          //                 Icons.camera_enhance,
          //                 size: screenWidth * 0.180,
          //                 color: Colors.black54,
          //               )
          //             : null,
          //       ),
          //     ),
          //   ),
          // ),
          SizedBox(height: 30),
          Center(
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: Colors.red.withOpacity(0.3), // Light red color
                      spreadRadius: 40, // Spread radius
                      blurRadius: 80,
                      blurStyle: BlurStyle.solid // Blur radius
                      ),
                  BoxShadow(
                    color: Colors.red.withOpacity(0.3), // Transparent color
                    spreadRadius: 40,
                    blurRadius: 80, // Some blur
                  ),
                ],
              ),
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromARGB(255, 238, 97, 97),
                  padding: const EdgeInsets.all(30),
                  shape: const CircleBorder(),
                ),
                onPressed: () {
                  _sos();
                },
                child: const Text(
                  'SOS',
                  style: TextStyle(
                      fontSize: 40,
                      // fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold),
                ),
              ), //
            ),
          ),
        ],
      ),
    );
  }
}


        ///////////////////// Send the image URL and the emergency alert details to your backend//////////////////////////

        // var response = await http.post(
        //   Uri.parse('https://your-backend-url.com'),
        //   headers: <String, String>{
        //     'Content-Type': 'application/json; charset=UTF-8',
        //   },
        //   body: jsonEncode(<String, String>{
        //     'imageUrl': downloadUrl,
        //     // Replace the following with your actual data
        //     'userName': 'YourUserName',
        //     'dateTime': DateTime.now().toString(),
        //     'location': 'YourLocation',
        //   }),
        // );
 
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:she_secure/Widgets/global_var.dart';
import 'package:mapmyindia_gl/mapmyindia_gl.dart';

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key});

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;

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
        emergencyContact1 = results.data()!['emergencyContact1'];
        emergencyContact2 = results.data()!['emergencyContact2'];
        emergencyContact3 = results.data()!['emergencyContact3'];
        emergencyContact4 = results.data()!['emergencyContact4'];
        emergencyName1 = results.data()!['emergencyName1'];
        emergencyName2 = results.data()!['emergencyName2'];
        emergencyName3 = results.data()!['emergencyName3'];
        emergencyName4 = results.data()!['emergencyName4'];

        print(emergencyName1);
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMyData();
  }

  @override
  Widget build(BuildContext context) {
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
                onPressed: () {},
                icon: const Icon(
                  Icons.arrow_back_ios_new_sharp,
                  color: Colors.white,
                ),
              ),
              title: const Center(
                  child: Text(
                'Emergency Call',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
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
          Padding(
            padding: EdgeInsets.only(left: 20, top: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Contacts',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    fontFamily: "Montserrat"),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 4,
              itemBuilder: (context, index) {
                String emergencyName = '';
                String emergencyContact = '';
                switch (index) {
                  case 0:
                    emergencyName = emergencyName1;
                    emergencyContact = emergencyContact1;
                    break;
                  case 1:
                    emergencyName = emergencyName2;
                    emergencyContact = emergencyContact2;
                    break;
                  case 2:
                    emergencyName = emergencyName3;
                    emergencyContact = emergencyContact3;
                    break;
                  case 3:
                    emergencyName = emergencyName4;
                    emergencyContact = emergencyContact4;
                    break;
                }
                return ListTile(
                  title: Text(
                    emergencyName,
                    style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(emergencyContact),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

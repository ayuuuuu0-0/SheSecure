import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:she_secure/Widgets/global_var.dart';
import 'package:mapmyindia_gl/mapmyindia_gl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Completer<GoogleMapController> _controller = Completer();

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
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // MapmyIndiaAccountManager.setMapSDKKey(ACCESS_TOKEN);
    MapmyIndiaAccountManager.setRestAPIKey("52a026e0c0b82834480722ac29ae618a");
    MapmyIndiaAccountManager.setAtlasClientId(
        "96dHZVzsAutDLGyvMzPjsL4E33c6DiGXvGkkCjbuXfryx2bNiXqriKRGD-8pZiQWtwgLYI_i-s0_jHCB-43CIUB9d1MUOcow");
    MapmyIndiaAccountManager.setAtlasClientSecret(
        "lrFxI-iSEg-sVir2rf0wD3mwCRrpb2JxFsP60eTPJfe5XSSRJVId9Y6FV-Kg1e4yP5l2HWDjd36pOiQ-uJc2zI5krkvPt8fe-F-evuBnP-Q=");

    uid = FirebaseAuth.instance.currentUser!.uid;
    userEmail = FirebaseAuth.instance.currentUser!.email!;
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
                icon: const Icon(Icons.settings),
              ),
              title: const Center(
                  child: Text(
                'SheSecure',
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
          Card(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 10, 0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Need Help?',
                      style: TextStyle(
                        fontSize: 20,
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
                      'We are here to assist you',
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
          // Expanded(
          //   child: GoogleMap(
          //     initialCameraPosition: CameraPosition(
          //       target: const LatLng(37.42796133580664, -122.085749655962),
          //       zoom: 14,
          //     ),
          //     mapType: MapType.normal,
          //     myLocationEnabled: true,
          //     onMapCreated: (GoogleMapController controller) {
          //       _controller.complete(controller);
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}

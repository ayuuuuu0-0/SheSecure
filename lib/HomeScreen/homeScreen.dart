import 'dart:async';
import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:she_secure/LoginScreen/login_screen.dart';
import 'package:she_secure/Widgets/global_var.dart';
import 'package:flutter/cupertino.dart';
import 'package:shake/shake.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late CameraPosition _kGooglePlex;
  Completer<GoogleMapController> _controller = Completer();

  FirebaseAuth _auth = FirebaseAuth.instance;

  Set<Marker> _markers = {};

  String _selectedSeverity = 'Low';

  ShakeDetector? detector;

  // ...

  // This function is called when the Google Map is created
  void _onMapCreated(GoogleMapController controller) async {
    // Get the current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    print('Position: $position');

    // Create a new Marker with the current location and add it to the set
    Marker marker = Marker(
      markerId: MarkerId('current_location'),
      position: LatLng(position.latitude, position.longitude),
      infoWindow: InfoWindow(title: 'Current Location'),
    );
    _markers.add(marker);

    // Print the marker coordinates
    print(
        'Marker coordinates: ${marker.position.latitude}, ${marker.position.longitude}');

    // Update the state of the markers
    setState(() {});

    // Move the camera to the current location

    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 14,
        ),
      ),
    );
  }

  Future<void> _setInitialLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition();
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

  getEmergencyImage() {
    FirebaseFirestore.instance
        .collection('EmergencyImage')
        .doc(uid)
        .get()
        .then((results) {
      setState(() {
        userEmergencyImage = results.data()!['userEmergencyImage'];
      });
    });
  }

  _setting() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return FractionallySizedBox(
            heightFactor: 1.25,
            widthFactor: 1,
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(children: <Widget>[
                CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.blueGrey,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(userImageUrl),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '   Name',
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold),
                    )),
                const SizedBox(
                  height: 10,
                ),
                Container(
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(
                        getUserName,
                        style: const TextStyle(
                            fontSize: 15,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                const SizedBox(
                  height: 10,
                ),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '   Email',
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold),
                    )),
                const SizedBox(
                  height: 10,
                ),
                Container(
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(
                        userEmail,
                        style: const TextStyle(
                            fontSize: 15,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                const SizedBox(
                  height: 10,
                ),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '   Password',
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold),
                    )),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Text(
                      '*********',
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(255, 159, 151, 151),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    'Update Credentials',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    side: const BorderSide(color: Color(0XFFFF7373), width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
                  },
                  child: const Text('Logout',
                      style: TextStyle(color: Color(0XFFFF7373))),
                ),
              ]),
            ),
          );
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

    // Now you can send jsonData in your HTTP request

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.fromLTRB(40, 60, 40, 60),
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
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        ' Severity Level',
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold),
                      )),
                  const SizedBox(height: 10),
                  CupertinoPicker(
                    onSelectedItemChanged: (int index) {
                      setState(() {
                        _selectedSeverity = ['Low', 'Medium', 'High'][index];
                      });
                    },
                    itemExtent: 32.0,
                    children: const <Widget>[
                      Text('Low'),
                      Text('Medium'),
                      Text('High'),
                    ],
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
    Map<String, dynamic> data = {
      'date': formattedDate,
      'lat': position.latitude,
      'lng': position.longitude,
      'state': place.administrativeArea,
      'city': place.locality,
      'pincode': place.postalCode,
      'severity': _selectedSeverity,
      'emergencyImage':
          userEmergencyImage, // replace with your actual image data
    };

    // Convert the data to a JSON string
    String jsonData = jsonEncode(data);
    print(jsonData);
    // new commit 1
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
                    'Emergency Alert sent',
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
    _setInitialLocation();
    getMyData();
    getEmergencyImage();
    detector = ShakeDetector.autoStart(onPhoneShake: () {
      _sos();
    });
  }

  @override
  void dispose() {
    detector?.stopListening();
    super.dispose();
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
                onPressed: () {
                  _setting();
                },
                icon: const Icon(Icons.settings),
              ),
              title: const Center(
                  child: Text(
                'SheSecure',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                  fontSize: 25,
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
          Expanded(
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: const LatLng(0, 0),
                    zoom: 14,
                  ),
                  mapType: MapType.normal,
                  markers: _markers,
                  compassEnabled: true,
                  myLocationEnabled: true,
                  onMapCreated: _onMapCreated,
                ),
                //),

                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color:
                                Colors.red.withOpacity(0.3), // Light red color
                            spreadRadius: 40, // Spread radius
                            blurRadius: 80,
                            blurStyle: BlurStyle.solid // Blur radius
                            ),
                        BoxShadow(
                          color:
                              Colors.red.withOpacity(0.3), // Transparent color
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
          ),
        ],
      ),
    );
  }
}

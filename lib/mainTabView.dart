import 'package:flutter/material.dart';
import 'package:she_secure/PhoneScreen/phoneScreen.dart';
import 'package:she_secure/Buttons/tabBar.dart';
import 'package:she_secure/CamScreen/cameraScreen.dart';
import 'package:she_secure/HomeScreen/homeScreen.dart';

class MainTabView extends StatefulWidget {
  const MainTabView({super.key});

  @override
  State<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView> {
  int selectTab = 0;
  final PageStorageBucket pageBucket = PageStorageBucket();
  Widget currentTab = const HomeScreen();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: PageStorage(bucket: pageBucket, child: currentTab),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: SizedBox(
          width: 70,
          height: 70,
          child: InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CameraScreen()));
            },
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 243, 228, 242),
                  borderRadius: BorderRadius.circular(35),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 2,
                    )
                  ]),
              child: Icon(
                Icons.camera_alt,
                color: Colors.black54,
                size: 35,
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          clipBehavior: Clip.antiAlias,
          shape: CircularNotchedRectangle(),
          //  child:
          //   Container(
          // decoration: BoxDecoration(color: Colors.white, boxShadow: const [
          //   BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, -2))
          // ]),
          // height: kToolbarHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TabButton(
                  icon: "assets/images/home.png",
                  selectIcon: "assets/images/home_fill.png",
                  isActive: selectTab == 0,
                  onTap: () {
                    selectTab = 0;
                    currentTab = HomeScreen();
                    if (mounted) {
                      setState(() {});
                    }
                  }),
              // TabButton(
              //     icon: "assets/images/hash_white.png",
              //     selectIcon: "assets/images/hash_black.png",
              //     isActive: selectTab == 1,
              //     onTap: () {
              //       selectTab = 1;
              //       currentTab = CommunityTab();
              //       if (mounted) {
              //         setState(() {});
              //       }
              //     }),
              const SizedBox(
                width: 40,
              ),
              TabButton(
                  icon: "assets/images/phone.png",
                  selectIcon: "assets/images/phone_fill.png",
                  isActive: selectTab == 1,
                  onTap: () {
                    selectTab = 1;
                    currentTab = const PhoneScreen();
                    if (mounted) {
                      setState(() {});
                    }
                  }),
              // TabButton(
              //     icon: "assets/images/profile_white.png",
              //     selectIcon: "assets/images/profile_black.png",
              //     isActive: selectTab == 3,
              //     onTap: () {
              //       selectTab = 3;
              //       currentTab = const ProfileScreen();
              //       if (mounted) {
              //         setState(() {});
              //       }
              //     })
            ],
          ),
        ));
    //);
  }
}

import 'package:attendance_app/components/colors.dart';
import 'package:attendance_app/provider/Authentication_provider.dart';
import 'package:attendance_app/provider/Get_User_Data.dart';
import 'package:attendance_app/utils/Routes_Names.dart';
import 'package:attendance_app/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class Profile_page extends StatefulWidget {
  const Profile_page({super.key});

  @override
  _Profile_pageState createState() => _Profile_pageState();
}

class _Profile_pageState extends State<Profile_page> {
  double screenhight = 0;
  double screeenwidth = 0;

  @override
  void initState() {
    super.initState();
    // Access the Fetch_Data provider
    final dataProvider = Provider.of<UserDataProvider>(context, listen: false);
    // Fetch data when the screen is initially loaded
    // You may want to use FutureBuilder here to handle loading states
    dataProvider.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    // Access the Fetch_Data provider
    final dataProvider = Provider.of<UserDataProvider>(context, listen: false);
    final userprovider = Provider.of<Auth_Provider>(context, listen: false);
    screenhight = MediaQuery.of(context).size.height;
    screeenwidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          SystemNavigator.pop();
          return true;
        },
        child: Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton(
            backgroundColor: AppColors.white,
            onPressed: () {
              Navigator.pushNamed(context, Routesname.Edit_profile);
            },
            child: const Icon(
              Icons.edit,
              color: AppColors.green,
            ),
          ),
          appBar: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            title: const Text(
              "Profile",
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: () async {
                    userprovider.logout();
                    utils.showToastMessage("Logout successfully");
                    Navigator.pushNamed(context, Routesname.login);
                  },
                  child: Lottie.asset(
                    'assets/signout.json',
                    height: 30,
                  ),
                ),
              )
            ],
            centerTitle: true,
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              await dataProvider.fetchData();
            },
            child: Consumer<UserDataProvider>(
              builder: (context, dataProvider, child) {
                final Map<String, dynamic> data = dataProvider.data;

                return ListView(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Center(
                            child: Container(
                              width: 130, // Adjust the width as needed
                              height: 130, // Adjust the height as needed
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: AppColors.white, width: 4),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    12), // Adjust the radius as needed
                                child: data['image'] != null
                                    ? CachedNetworkImage(
                                        imageUrl: data['image'] ?? '',
                                        placeholder: (context, url) =>
                                            const CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      )
                                    : Image.asset('assets/logo.png'),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Name:",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  height: kToolbarHeight,
                                  width: screeenwidth,
                                  margin: const EdgeInsets.only(),
                                  padding: const EdgeInsets.only(),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border:
                                          Border.all(color: AppColors.black)),
                                  child: Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Icon(FontAwesomeIcons.person),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          data['name'] ?? "",
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Text(
                                  "DOB:",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  height: kToolbarHeight,
                                  width: screeenwidth,
                                  margin: const EdgeInsets.only(),
                                  padding: const EdgeInsets.only(),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border:
                                          Border.all(color: AppColors.black)),
                                  child: Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child:
                                            Icon(FontAwesomeIcons.cakeCandles),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          data['age'] ?? "",
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Text(
                                  "Address:",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  height: kToolbarHeight,
                                  width: screeenwidth,
                                  margin: const EdgeInsets.only(),
                                  padding: const EdgeInsets.only(),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border:
                                          Border.all(color: AppColors.black)),
                                  child: Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child:
                                            Icon(FontAwesomeIcons.locationDot),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          data['location'] ?? "",
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

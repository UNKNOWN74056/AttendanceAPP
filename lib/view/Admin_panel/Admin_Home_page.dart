import 'package:attendance_app/provider/Authentication_provider.dart';
import 'package:attendance_app/provider/Get_User_Data.dart';
import 'package:attendance_app/utils/Routes_Names.dart';
import 'package:attendance_app/utils/utils.dart';
import 'package:attendance_app/view/Admin_panel/Bild_view_pge.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Admin_page extends StatefulWidget {
  const Admin_page({super.key});

  @override
  State<Admin_page> createState() => _Admin_pageState();
}

class _Admin_pageState extends State<Admin_page> {
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
    final userprovider = Provider.of<Auth_Provider>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          child: Consumer<UserDataProvider>(
            builder: (context, dataProvider, _) {
              final Map<String, dynamic> data = dataProvider.data;
              return ListView(
                children: [
                  UserAccountsDrawerHeader(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/logo.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    accountName: Text(
                      data['name'],
                      style: const TextStyle(fontSize: 20),
                    ),
                    accountEmail: Text(
                      data['email'],
                    ),
                  ),
                  const ListTile(
                    leading: Icon(Icons.lock),
                    title: Text("Change password"),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.logout,
                      color: Colors.green,
                    ),
                    title: GestureDetector(
                        onTap: () async {
                          userprovider.logout();
                          utils.showToastMessage("Logout successfully");
                          Navigator.pushNamed(context, Routesname.login);
                        },
                        child: const Text("Log out")),
                  ),
                ],
              );
            },
          ),
        ),
        backgroundColor: const Color(0xff264a52),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: const Text(
            'Admin Dashboard',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: buildGridView(context),
        ),
      ),
    );
  }
}

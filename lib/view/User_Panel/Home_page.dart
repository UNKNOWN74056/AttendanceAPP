import 'package:attendance_app/components/colors.dart';
import 'package:attendance_app/provider/Get_User_Data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double screenhight = 0;
  double screeenwidth = 0;
  String _month = DateFormat("MMMM").format(DateTime.now());

  @override
  void initState() {
    super.initState();
    Provider.of<UserDataProvider>(context, listen: false)
        .fetchCheckInOutTimes();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser!.email;
    screenhight = MediaQuery.of(context).size.height;
    screeenwidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          SystemNavigator.pop();
          return true;
        },
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(top: 32),
                  child: Text(
                    'My Attendance',
                    style: TextStyle(
                      fontSize: screeenwidth / 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Stack(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(top: 32),
                      child: Text(
                        _month,
                        style: TextStyle(
                          fontSize: screeenwidth / 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      margin: const EdgeInsets.only(top: 32),
                      child: GestureDetector(
                        onTap: () async {
                          final pickedmonth = await showMonthYearPicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2023),
                              lastDate: DateTime(2099));
                          if (pickedmonth != null) {
                            setState(() {
                              _month = DateFormat("MMMM").format(pickedmonth);
                            });
                          }
                        },
                        child: Text(
                          "pick month",
                          style: TextStyle(
                            fontSize: screeenwidth / 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Gutter(),
                Expanded(
                  child: SingleChildScrollView(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("users")
                          .doc(currentUser)
                          .collection("records")
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          final snap = snapshot.data!.docs;

                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snap.length,
                            itemBuilder: (context, index) {
                              // Convert timestamp to DateTime
                              final DateTime date =
                                  (snap[index]['date'] as Timestamp).toDate();

                              // Use 'MMMM' to format the month
                              final String formattedMonth =
                                  DateFormat('MMMM').format(date);
                              return formattedMonth == _month
                                  ? Container(
                                      margin: EdgeInsets.only(
                                        top: index > 0 ? 12 : 0,
                                        left: 6,
                                        right: 6,
                                      ),
                                      height: 150,
                                      decoration: BoxDecoration(
                                        color: AppColors.white,
                                        boxShadow: const [
                                          BoxShadow(
                                            color:
                                                Color.fromARGB(159, 32, 29, 29),
                                            blurRadius: 10,
                                            offset: Offset(2, 2),
                                          )
                                        ],
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: Container(
                                            margin: const EdgeInsets.only(),
                                            decoration: BoxDecoration(
                                                color: AppColors.red,
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                            child: Center(
                                              child: Text(
                                                DateFormat('EE dd')
                                                    .format(date),
                                                style: TextStyle(
                                                    fontSize: screeenwidth / 20,
                                                    color: AppColors.white),
                                              ),
                                            ),
                                          )),
                                          Expanded(
                                            child: Container(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Check in",
                                                    style: TextStyle(
                                                      fontSize:
                                                          screeenwidth / 20,
                                                    ),
                                                  ),
                                                  Text(
                                                    snap[index].data() is Map &&
                                                            (snap[index].data()
                                                                    as Map)
                                                                .containsKey(
                                                                    'checkInTime')
                                                        ? (snap[index].data()
                                                                as Map)[
                                                            'checkInTime']
                                                        : '--:--',
                                                    style: TextStyle(
                                                      fontSize:
                                                          screeenwidth / 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Check out",
                                                    style: TextStyle(
                                                      fontSize:
                                                          screeenwidth / 20,
                                                    ),
                                                  ),
                                                  Text(
                                                    snap[index].data() is Map &&
                                                            (snap[index].data()
                                                                    as Map)
                                                                .containsKey(
                                                                    'checkOutTime')
                                                        ? (snap[index].data()
                                                                as Map)[
                                                            'checkOutTime']
                                                        : '--:--',
                                                    style: TextStyle(
                                                      fontSize:
                                                          screeenwidth / 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container();
                            },
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

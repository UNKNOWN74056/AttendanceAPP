import 'package:attendance_app/components/Mark_leave.dart';
import 'package:attendance_app/components/colors.dart';
import 'package:attendance_app/provider/Get_User_Data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_to_act/slide_to_act.dart';

class CheckPage extends StatefulWidget {
  const CheckPage({Key? key}) : super(key: key);

  @override
  _CheckPageState createState() => _CheckPageState();
}

class _CheckPageState extends State<CheckPage> {
  double screenhight = 0;
  double screeenwidth = 0;
  bool isDayCompleted = false;

  @override
  void initState() {
    super.initState();
    // Fetch user data and day completion status when the widget is initialized
    Provider.of<UserDataProvider>(context, listen: false).fetchUserData();
    checkDayCompletion();
  }

  Future<void> checkDayCompletion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime lastCheckedDate =
        DateTime.parse(prefs.getString('lastCheckedDate') ?? '');
    DateTime now = DateTime.now();
    if (lastCheckedDate.day != now.day || lastCheckedDate.month != now.month) {
      // Reset day completion status for a new day
      prefs.setBool('isDayCompleted', false);
      setState(() {
        isDayCompleted = false;
      });
    } else {
      setState(() {
        isDayCompleted = prefs.getBool('isDayCompleted') ?? false;
      });
    }
  }

  Future<void> markDayCompleted() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDayCompleted', true);
    prefs.setString('lastCheckedDate', DateTime.now().toString());
    setState(() {
      isDayCompleted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userDataProvider = Provider.of<UserDataProvider>(context);
    screenhight = MediaQuery.of(context).size.height;
    screeenwidth = MediaQuery.of(context).size.width;
    String checkInTime = "--:--";
    String checkOutTime = "--:--";

    if (userDataProvider.isCheckedIn) {
      checkInTime = DateFormat('hh:mm ').format(DateTime.now());
    } else {
      checkOutTime = DateFormat('hh:mm ').format(DateTime.now());
    }
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          SystemNavigator.pop();
          return true;
        },
        child: Scaffold(
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: AppColors.white,
            onPressed: () {
              // Show the MarkLeaveDialog when the button is pressed
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const MarkLeaveDialog();
                },
              );
            },
            label: const Text(
              "Mark leave",
              style: TextStyle(color: AppColors.blue),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(top: 32),
                  child: Text(
                    'Welcome',
                    style: TextStyle(fontSize: screeenwidth / 20),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Employee  ${userDataProvider.userName}",
                    style: TextStyle(
                        fontSize: screeenwidth / 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(top: 32),
                  child: Text(
                    'Today Status',
                    style: TextStyle(
                        fontSize: screeenwidth / 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 32),
                  height: 150,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(159, 32, 29, 29),
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Check in",
                                style: TextStyle(fontSize: screeenwidth / 20),
                              ),
                              Text(
                                checkInTime,
                                style: TextStyle(
                                  fontSize: screeenwidth / 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Check out",
                                style: TextStyle(fontSize: screeenwidth / 20),
                              ),
                              Text(
                                checkOutTime,
                                style: TextStyle(
                                  fontSize: screeenwidth / 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                      text: DateTime.now().day.toString(),
                      style: TextStyle(
                        color: AppColors.red,
                        fontSize: screeenwidth / 18,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: DateFormat(' MMMM yyyy').format(DateTime.now()),
                          style: const TextStyle(
                            color: AppColors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                StreamBuilder(
                  stream: Stream.periodic(const Duration(seconds: 1)),
                  builder: (context, snapshot) {
                    return Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        DateFormat("hh:mm:ss a").format(DateTime.now()),
                        style: TextStyle(fontSize: screeenwidth / 20),
                      ),
                    );
                  },
                ),
                isDayCompleted
                    ? Container(
                        margin: const EdgeInsets.only(top: 24),
                        child: const Text(
                          "Your day is completed today!",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      )
                    : Builder(
                        builder: (context) {
                          final GlobalKey<SlideActionState> key = GlobalKey();
                          return SlideAction(
                            text: userDataProvider.isCheckedIn
                                ? "Slide to check out"
                                : "Slide to check in",
                            textStyle: TextStyle(
                              color: AppColors.black,
                              fontSize: screeenwidth / 20,
                            ),
                            outerColor: AppColors.white,
                            innerColor: AppColors.blue,
                            key: key,
                            onSubmit: () async {
                              await Future.delayed(
                                const Duration(seconds: 1),
                                () {
                                  key.currentState!.reset();
                                },
                              );

                              if (userDataProvider.isCheckedIn) {
                                userDataProvider.checkOut();
                                markDayCompleted();
                              } else {
                                userDataProvider.checkIn();
                              }

                              return null;
                            },
                          );
                        },
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

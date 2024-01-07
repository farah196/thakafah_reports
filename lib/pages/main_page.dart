import 'package:flutter/material.dart';
import 'package:thakafah_reports/core/services/timesheet_prefrence.dart';
import 'package:thakafah_reports/pages/profile_page.dart';
import 'package:thakafah_reports/pages/timesheet_page.dart';
import '../constant/app_strings.dart';
import '../core/model/task_model.dart';
import '../shared_widget/app_bar_widget.dart';
import 'add_task_page.dart';
import 'calendar_page.dart';
import 'leave_page.dart';
import 'login_page.dart';
DateTime selectedDay = DateTime.now();
class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool clickedCentreFAB = false;
  int selectedIndex = 0;
  String text = "Home";

  void updateTabSelection(int index, String buttonText) {
    setState(() {
      selectedIndex = index;
      text = buttonText;
      clickedCentreFAB = false;
    });
  }



  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    AppBarWidget.init(
        context,
        [
          PopupMenuButton<String>(
            iconColor: Colors.white,
            onSelected: (value) {
              handleClick(value);
            },
            itemBuilder: (BuildContext context) {
              return {'logout'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: const Text(
                    Strings.logout,
                    style: TextStyle(
                        color: Colors.black38,
                        fontFamily: 'Tajawal',
                        fontSize: 13),
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                  ),
                );
              }).toList();
            },
          )
        ],
        false);
    bool keyboardIsOpened = MediaQuery.of(context).viewInsets.bottom != 0.0;
    List<Widget> widgetOptions = <Widget>[
      const CalendarPage(),
      const TimeSheetPage(),
       AddTaskPage(edit: false,taskObj:Task()),
      // Align(
      //   alignment: FractionalOffset.bottomCenter,
      //   child: AnimatedContainer(
      //     duration: const Duration(milliseconds: 250),
      //     //if clickedCentreFAB == true, the first parameter is used. If it's false, the second.
      //     height: clickedCentreFAB ? MediaQuery.of(context).size.height : 10.0,
      //     width: clickedCentreFAB ? MediaQuery.of(context).size.height : 10.0,
      //     decoration: BoxDecoration(
      //         borderRadius:
      //             BorderRadius.circular(clickedCentreFAB ? 0.0 : 300.0),
      //         color: theme.primaryColorLight),
      //   ),
      // ),
      const LeavePage(),
      const ProfilePage(),
    ];
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBarWidget.mainAppBarSharedWidget(),
        resizeToAvoidBottomInset: false,
        body: Container(
          alignment: Alignment.center,
          child: widgetOptions.elementAt(selectedIndex),
        ),

        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: keyboardIsOpened ||selectedIndex == 2||selectedIndex == 3?
        SizedBox() : FloatingActionButton (

          backgroundColor: theme.primaryColorLight,
          onPressed: () {
            setState(() {
              clickedCentreFAB = true; //to update the animated container
              selectedIndex = 2;
            });
          },
          tooltip: Strings.addNewTask,
          elevation: 4.0,
          child: Container(
            margin: const EdgeInsets.all(15.0),
            child: const Icon(Icons.add),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          height: MediaQuery.of(context).size.height*0.07,
          //color of the BottomAppBar
          color: Colors.white,
          child:  Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    updateTabSelection(4, "Profile");
                  },
                  iconSize: 23.0,
                  icon: Icon(
                    Icons.person,
                    color: selectedIndex == 4
                        ? theme.primaryColorLight
                        : Colors.grey.shade400,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    updateTabSelection(3, "Leave");
                  },
                  iconSize: 23.0,
                  icon: Icon(
                    Icons.perm_device_info,
                    color: selectedIndex == 3
                        ? theme.primaryColorLight
                        : Colors.grey.shade400,
                  ),
                ),
                keyboardIsOpened ||selectedIndex == 3? IconButton(
                  onPressed: () {
                    updateTabSelection(2, "Add task");
                  },
                  iconSize: 23.0,
                  icon: Icon(
                    Icons.add_circle,
                    color: selectedIndex == 2
                        ? theme.primaryColorLight
                        : Colors.grey.shade400,
                  ),
                ) :const SizedBox(
                  width: 50.0,
                ),
                IconButton(
                  onPressed: () {
                    updateTabSelection(1, "TimeSheet");
                  },
                  iconSize: 23.0,
                  icon: Icon(
                    Icons.view_timeline_sharp,
                    color: selectedIndex == 1
                        ? theme.primaryColorLight
                        : Colors.grey.shade400,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    updateTabSelection(0, "Home");
                  },
                  iconSize: 23.0,
                  icon: Icon(
                    Icons.home,
                    color: selectedIndex == 0
                        ? theme.primaryColorLight
                        : Colors.grey.shade400,
                  ),
                ),
              ],
            ),

        ));
  }

  void handleClick(String value) {
    TimeSheetPreference.logout();
    // model.destroySession();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  void dispose() {
    selectedIndex = 0;
    super.dispose();
  }
}

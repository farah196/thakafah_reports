import 'package:day_night_time_picker/lib/constants.dart';
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:thakafah_reports/shared_widget/app_theme.dart';
import 'package:thakafah_reports/shared_widget/snackbar.dart';
import '../constant/app_strings.dart';
import '../constant/images.dart';
import '../core/model/profile_model.dart';
import '../core/services/api_service.dart';
import '../core/services/timesheet_prefrence.dart';
import '../locator.dart';
import '../shared_widget/notification_handler.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Time _time = Time(hour: 0, minute: 00, second: 00);

  @override
  void initState() {
    SnackbarShare.init(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return FutureBuilder<ProfileDetails>(
      future: getUserInfo(),
      builder: (
        BuildContext context,
        AsyncSnapshot<ProfileDetails> snapshot,
      ) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: double.infinity,
              color: Colors.white,
              child: LoadingAnimationWidget.fourRotatingDots(
                color: theme.primaryColor,
                size: 30,
              ));
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return mainWidget(snapshot.data!, theme);
          } else {
            return mainWidget(ProfileDetails(name: "", gender: ""), theme);
          }
        } else {
          return Text('Error');
        }
      },
    );
  }

  Widget mainWidget(ProfileDetails profileOnj, ThemeData theme) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.33,
                  top: 20,
                  right: 15,
                  left: 15),
              decoration: BoxDecoration(
                color: theme.primaryColorLight,
                borderRadius: BorderRadius.circular(15),
                image: const DecorationImage(
                  image: AssetImage(Images.login_background),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.primaryColorLight,
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 1), // changes position of shadow
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              margin: const EdgeInsets.only(right: 25, left: 25, bottom: 30),
              decoration: BoxDecoration(
                color: AppTheme.category3.withOpacity(0.3),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[100]!,
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: const Offset(1, 1), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 130),
                child: Column(
                  children: [
                    GestureDetector(
                        onTap: () {
                          SnackbarShare.showMessage(
                              Strings.serviceNotAvailable);
                        },
                        child: itemProfile(
                            Icons.edit, Strings.editProfile, theme)),
                    const Divider(),
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(showPicker(
                            okStyle: theme.textTheme.titleMedium!,
                            okText: Strings.setNotifications,
                            disableAutoFocusToNextInput: true,
                            showSecondSelector: false,
                            elevation: 1,
                            showCancelButton: false,
                            value: _time,
                            onChange: (Time time) {
                              NotificationService.notificationService
                                  .init(time.hour,time.minute)
                                  .then((value) {
                                SnackbarShare.showMessage(
                                    Strings.submitNotifications);
                                // Navigator.pop(context);
                              });
                            },

                            // iosStylePicker: iosStyle,
                            minHour: 0,
                            maxHour: 23,
                            is24HrFormat: true,
                          ));
                        },
                        child: itemProfile(Icons.notification_add,
                            Strings.notifications, theme)),
                    const Divider(),
                    GestureDetector(
                        onTap: () {
                          TimeSheetPreference.logout();
                          // model.destroySession();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const LoginPage()),
                            (route) => false,
                          );
                        },
                        child:
                            itemProfile(Icons.logout, Strings.logout, theme)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.28),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60, // Image radius
                    backgroundImage: AssetImage(profileOnj.gender != null &&
                            profileOnj.gender! == "male"
                        ? Images.profileImageM
                        : Images.profileImageF),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      profileOnj.name != null ? profileOnj.name! : "User",
                      style: theme.textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget itemProfile(IconData icon, String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(right: 30, left: 30, top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            icon,
            size: 17,
            color: theme.primaryColorLight,
          ),
          Text(
            title,
            style: theme.textTheme.titleMedium,
          ),
          const Icon(
            Icons.arrow_right_sharp,
            size: 17,
            color: Colors.black38,
          ),
        ],
      ),
    );
  }

  Future<ProfileDetails> getUserInfo() async {
    var profile = ProfileDetails();
    try {
      final ApiService _api = locator<ApiService>();
      var obj = await _api.getUserProfile();
      if (obj.result != null && obj.result!.success! == true) {
        profile = obj.result!.profile!;
      } else {
        print("444");
        profile = ProfileDetails();
      }
    } catch (e) {
      profile = ProfileDetails();
    }
    return profile;
  }

// showNotificationDialog(BuildContext context) {
//   // set up the button
//   Widget okButton = TextButton(
//     child: Text(
//      Strings.yes,
//     ),
//     onPressed: () async{
//
//
//
//        NotificationService.notificationService.init().then((value) {
//          SnackbarShare.showMessage(Strings.submitNotifications);
//          Navigator.pop(context);
//        });
//     });
//
//
//
//   Widget noButton = TextButton(
//     child: Text(Strings.cancel),
//     onPressed: () async {
//       NotificationService.notificationService.cancelAllNotifications();
//       SnackbarShare.showMessage(Strings.allNotificationsDeleted);
//       Navigator.pop(context);
//     },
//   );
//   // set up the AlertDialog
//   AlertDialog alert = AlertDialog(
//     title: Text(
//       Strings.notifications,
//       textDirection: TextDirection.rtl,
//     ),
//     content: Text(
//      Strings.notificationTitle,
//       textDirection: TextDirection.rtl,
//     ),
//     actions: [
//       noButton,
//       okButton,
//     ],
//   );
//
//   // show the dialog
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return alert;
//     },
//   );
// }
}

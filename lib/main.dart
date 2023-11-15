import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rive/rive.dart';
import 'package:thakafah_reports/core/services/timesheet_prefrence.dart';
import 'package:thakafah_reports/pages/login_page.dart';
import 'package:thakafah_reports/pages/main_page.dart';
import 'package:thakafah_reports/shared_widget/app_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:thakafah_reports/shared_widget/notification_handler.dart';
import 'core/services/api_service.dart';
import 'locator.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  final String? timeZoneName = await FlutterTimezone.getLocalTimezone();
  await NotificationService.notificationService.init();
  await NotificationService.notificationService.requestPermissions();

  tz.setLocalLocation(tz.getLocation(timeZoneName!));

  setupLocator();
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English, no country code
        Locale('ar', ''), // Arabic, no country code
        Locale('fr', ''),
        Locale('pt_BR', ''),
      ],
      theme: AppTheme.getAppTheme(),
      // routes: {
      //   AppRouting.loginScreenRoute: (context) => const LoginPage(),
      // },
      home: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    ThemeData theme = Theme.of(context);
    return

        FutureBuilder<Map<String, dynamic>>(
          future: loadPreferences(),
          builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return  SafeArea(
                child: Scaffold(
                    backgroundColor: Colors.white,
                  body:  Center(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.36,
                      width: MediaQuery.of(context).size.width * 0.74,
                      child: RiveAnimation.asset(
                        'assets/riv/logo.riv',
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                ),
              );
            }
            if (snapshot.hasData) {
              String auth = snapshot.data!['auth'];
              int userID = snapshot.data!['user_id'];
              bool success = snapshot.data!['success'];
              if (success == true) {
                if (auth.isNotEmpty && userID != 0) {
                  ApiService.auth = auth;
                  ApiService.userID = userID.toString();
                  return const MainPage();
                } else {
                  return const LoginPage();
                }
              } else {
                if (auth.isNotEmpty) {
                  TimeSheetPreference.logout();
                }
                return const LoginPage();
              }
            } else {
              return SafeArea(
                child: Scaffold(
                  backgroundColor: Colors.white,
                    body:  Center(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.36,
                        width: MediaQuery.of(context).size.width * 0.74,
                        child: RiveAnimation.asset(
                          'assets/riv/logo.riv',
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                ),
              );
            }
          },
        );
  }



  Future<bool> checkSession(String auth) async {
    ApiService _api = locator<ApiService>();

    var activeSession = await _api.checkSession(auth);

    var success = activeSession.error == null &&
        activeSession.result != null &&
        activeSession.result!.active! == true;

    return success;
  }

  Future<Map<String, dynamic>> loadPreferences() async {
    String auth = await TimeSheetPreference.getAuth();
    int userID = await TimeSheetPreference.getUserID();

    // bool onBoardingShow = await SchoolSharedPreference.getIfOnBoardingShow();
    // DateTime? expireSession = await SchoolSharedPreference.getExpireSession() ;
    var success = await checkSession(auth);
    return {
      'auth': auth,
      'user_id': userID,
      'success': success,
      // 'expire' : expireSession ,
      // 'show_onBoarding': onBoardingShow,
    };
  }
}

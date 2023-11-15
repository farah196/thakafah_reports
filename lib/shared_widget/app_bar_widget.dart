import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppBarWidget {
  static BuildContext? _context;
  static List<Widget> actionList = [];
  static bool? _showBack;

  static void init(BuildContext context,List<Widget> list,bool showBack) {
    _context = context;
    actionList = list;
    _showBack = showBack;
  }

  static PreferredSizeWidget mainAppBarSharedWidget() {
    final ThemeData theme = Theme.of(_context!);
    return AppBar(

backgroundColor: theme.primaryColorLight,
      leading: Visibility(
          visible: (Navigator.canPop(_context!) == true ? true : false) && _showBack == true,
          child: IconButton(
              icon:
              const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
              onPressed: () {
                if (Navigator.canPop(_context!) == true) {

                  Navigator.pop(_context!);
                } else {
                  SystemNavigator.pop();
                }
              })),
      actions: actionList,
      automaticallyImplyLeading: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.0),
          bottomRight: Radius.circular(30.0),
        ),
      ),
      // Add any additional properties to customize the AppBar
      // such as background color, text style, etc.
    );
  }
}

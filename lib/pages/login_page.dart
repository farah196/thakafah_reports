
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../constant/app_strings.dart';
import '../constant/images.dart';
import '../core/viewModels/login_model.dart';
import '../core/viewstate.dart';
import '../shared_widget/button_widget.dart';
import '../shared_widget/snackbar.dart';
import '../shared_widget/text_field_widget.dart';
import 'base_view.dart';
import 'main_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>  {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode userNameFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  String username = "";
  String password = "";

  @override
  void initState() {
    SnackbarShare.init(context);
    super.initState();
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text(Strings.areYouSure),
        content: new Text(Strings.exitApp),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text(Strings.no),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: new Text(Strings.yes),
          ),
        ],
      ),
    )) ?? false;
  }


  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return WillPopScope(
        onWillPop : _onWillPop,
        child: BaseView<LoginModel>(
            onModelReady: (model) => model.msg,
            builder: (context, model, child) {
              return model.state == ViewState.busy
                  ? Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.white,
                      child: LoadingAnimationWidget.fourRotatingDots(
                          color: theme.primaryColorLight,
                          size: 30,
                      ))
                  : Scaffold(
                        resizeToAvoidBottomInset: true,
                        body: Stack(
                          children: [
                            Image.asset(Images.login_background),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.55,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: const Offset(
                                            0, 1), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal:
                                          MediaQuery.of(context).size.width * 0.1,
                                    ),
                                    child:  Column(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(top: 140),
                                          child: SharedEditText(
                                            textEditingController:
                                                usernameController,
                                            focus: userNameFocus,
                                            label: Strings.email,
                                            icon: const Icon(
                                              Icons.email,
                                              size: 20,
                                            ),
                                            onChange: (value) {
                                              username = value;
                                              // usernameController.text = value;
                                            },
                                            onSubmit: (value) {
                                              username = value;
                                              usernameController.text = value;
                                            },
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(top: 15),
                                          child: SharedEditText(
                                            textEditingController:
                                                passwordController,
                                            label: Strings.password,
                                            focus: passwordFocus,
                                            icon: const Icon(
                                              Icons.lock,
                                              size: 20,
                                            ),
                                            isObscureText: true,
                                          ),
                                        ),
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          margin: const EdgeInsets.only(top: 25),
                                          child: SharedButton(
                                            buttonLabel: Strings.login,
                                            onClick: () {
                                              usernameController
                                                          .text.isNotEmpty &&
                                                      passwordController
                                                          .text.isNotEmpty
                                                  ? loginProcess(model, context)
                                                  : SnackbarShare.showMessage(
                                                      Strings.emptyField);
                                            },
                                          ),
                                        )
                                      ],
                                      ),
                                  )),
                            ),
                            Align(
                                alignment:
                                    userNameFocus.hasFocus == true || passwordFocus.hasFocus == true
                                        ? Alignment.centerRight
                                        : Alignment.center,
                                child: Padding(
                                    padding: EdgeInsets.only(
                                        bottom: userNameFocus.hasFocus  == true ||
                                            passwordFocus.hasFocus == true
                                            ? MediaQuery.of(context).size.height *
                                            0.25
                                            : MediaQuery.of(context).size.height *
                                            0.1,
                                        right: userNameFocus.hasFocus  == true ||
                                            passwordFocus.hasFocus == true
                                            ? MediaQuery.of(context).size.width *
                                            0.05
                                            : 0),
                                    child: ClipRect(
                                        child: Image.asset(
                                      Images.logo_transparent,
                                      height: userNameFocus.hasFocus  == true ||
                                          passwordFocus.hasFocus == true
                                          ? MediaQuery.of(context).size.height *
                                              0.1
                                          : MediaQuery.of(context).size.height *
                                              0.5,
                                      width: userNameFocus.hasFocus  == true ||
                                          passwordFocus.hasFocus == true
                                          ? MediaQuery.of(context).size.width *
                                              0.2
                                          : MediaQuery.of(context).size.width *
                                              0.5,
                                    )))),
                          ],
                        ),
                      );
            }));
  }

  @override
  void dispose() {
    userNameFocus.dispose();
    passwordFocus.dispose();
    super.dispose();
  }

  Future<void> loginProcess(LoginModel model, BuildContext context) async {
    await model
        .login(
      usernameController.text,
      passwordController.text,
      context,
    )
        .then((value) {

      if (value == true) {
        // model.changeState();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => const MainPage()),
        );
        FocusManager.instance.primaryFocus?.unfocus();
      } else {
        SnackbarShare.showMessage(Strings.login_error);
      }
    });
  }

}

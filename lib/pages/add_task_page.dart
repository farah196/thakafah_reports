import 'package:duration_picker/duration_picker.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/material.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:thakafah_reports/core/viewModels/add_model.dart';
import 'package:thakafah_reports/pages/main_page.dart';
import '../constant/app_strings.dart';
import '../core/model/task_model.dart';
import '../core/model/title_model.dart';
import '../core/services/timesheet_prefrence.dart';
import '../core/viewstate.dart';
import '../shared_widget/app_bar_widget.dart';
import '../shared_widget/button_widget.dart';
import '../shared_widget/snackbar.dart';
import '../shared_widget/text_field_widget.dart';
import 'base_view.dart';

class AddTaskPage extends StatefulWidget {
  final bool edit;
  final Task taskObj;

  const AddTaskPage({Key? key, required this.edit, required this.taskObj})
      : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  TextEditingController descController = TextEditingController();
  TextEditingController hoursController = TextEditingController();
  TextEditingController minutesController = TextEditingController();
  final tooltipController = JustTheController();

  String hours = '00';
  String minutes = '00';

  @override
  void initState() {
    SnackbarShare.init(context);
    if (widget.edit) {
      AppBarWidget.init(context, [], true);
      descController.text = widget.taskObj.desc!;
    }
    TimeSheetPreference.getShowDuration().then((value) {
      if (value == true) {
        Future.delayed(const Duration(seconds: 1), () {
          tooltipController.showTooltip(immediately: false);
        });
        tooltipController.addListener(() {
          // Prints the enum value of [TooltipStatus.isShowing] or [TooltipStatus.isHiding]
          print('controller: ${tooltipController.value}');
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return BaseView<AddModel>(
        onModelReady: (model) => model.getTitle(widget.edit, widget.taskObj),
        builder: (context, model, child) {
          return model.state == ViewState.busy
              ? Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.white,
                  child: LoadingAnimationWidget.fourRotatingDots(
                    color: theme.primaryColor,
                    size: 30,
                  ))
              : mainWidget(model, theme);
        });
  }

  Widget mainWidget(AddModel model, ThemeData theme) {

    FirebasePerformance _performance = FirebasePerformance.instance;
    bool _isPerformanceCollectionEnabled = false;
    var hours = "";
    var minutes = "";
    if (widget.edit) {
      List<String> parts = widget.taskObj.duration.toString().split(".");
      print("******   ${parts[0]}");
      hours = parts[0].padLeft(2, '0');
      print("******   $hours :  $minutes");
      minutes = parts[1];
    }
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: widget.edit
            ? AppBarWidget.mainAppBarSharedWidget()
            : AppBar(
                toolbarHeight: 0,
              ),
        body: SingleChildScrollView(
          child: Column(
            children: [


              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20, left: 20),
                        child: OutlinedButton(
                          onPressed: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: ColorScheme.light(
                                        primary: theme.primaryColorLight,
                                        // header background color
                                        onPrimary: Colors.white,
                                        // header text color
                                        onSurface:
                                            Colors.black, // body text color
                                      ),
                                      textButtonTheme: TextButtonThemeData(
                                        style: TextButton.styleFrom(
                                          primary:
                                              Colors.black, // button text color
                                        ),
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                                cancelText: Strings.cancel,
                                initialDate: selectedDay,
                                //get today's date
                                firstDate: DateTime(2000),
                                //DateTime.now() - not to allow to choose before today.
                                lastDate: DateTime(2101));

                            if (pickedDate != null) {
                              model.updateFormattedDate(pickedDate);
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                                width: 1, color: theme.primaryColorLight),
                          ),
                          child: Text(
                            model.formattedDate,
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Tajawal",
                                color: theme.primaryColorLight),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text(
                          widget.edit ? Strings.editTask : Strings.addNewTask,
                          style: theme.textTheme.displayLarge,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 20, left: 20),
                child: Divider(),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 10, right: 20, left: 20, bottom: 10),
                child: Column(
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.33,
                        child: DropdownButton<TitleM>(
                          value: model.selectedTitle,
                          icon: const Icon(Icons.arrow_drop_down_rounded),
                          elevation: 16,
                          alignment: Alignment.topRight,
                          style: const TextStyle(color: Colors.black38),
                          // underline: Container(
                          //   height: 2,
                          //   color: theme.primaryColor,
                          // ),
                          onChanged: (TitleM? value) {
                            model.setTitle(value!);
                          },
                          items: model.titles
                              .map<DropdownMenuItem<TitleM>>((TitleM value) {
                            return DropdownMenuItem<TitleM>(
                              value: value,
                              child: Center(
                                child: Text(
                                  value.name!,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontFamily: "Tajawal",
                                      color: Colors.black),
                                  textDirection: TextDirection.rtl,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.15,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: Text(
                          Strings.taskSubject,
                          style: theme.textTheme.bodyLarge,
                        ),
                      ),
                    ]),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        Strings.description,
                        style: theme.textTheme.bodyLarge,
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 15, right: 20, left: 20),
                      child: SharedEditText(
                        textEditingController: descController,
                        label: widget.edit
                            ? widget.taskObj.desc!
                            : Strings.taskDesc,
                        line: 3,
                        icon: const Icon(
                          Icons.description,
                          size: 20,
                        ),
                        isObscureText: false,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Text(
                       Strings.duration,
                        style: theme.textTheme.bodyLarge,
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(right: 20, left: 20, top: 15),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.09,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.15,
                                  child: Column(
                                    children: [
                                      Text(Strings.hour),
                                      SharedEditText(
                                        textEditingController: hoursController,
                                        label: widget.edit ? hours : "",
                                        isObscureText: false,
                                        keyboardType: TextInputType.number,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.05,
                                  child: Text(
                                    ":",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.15,
                                  child: Column(
                                    children: [
                                      Text(Strings.minute),
                                      SharedEditText(
                                        textEditingController:
                                            minutesController,
                                        label: widget.edit ? minutes : "",
                                        isObscureText: false,
                                        keyboardType: TextInputType.number,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                ),
                              ],
                            ),
                            JustTheTooltip(
                              controller: tooltipController,
                              onDismiss: () {
                                TimeSheetPreference.setShowDuration(false);
                              },
                              child: ElevatedButton(
                                  onPressed: () async {
                                    final resultingDuration =
                                        await showDurationPicker(
                                      context: context,
                                      initialTime: const Duration(seconds: 60),
                                      baseUnit: BaseUnit.minute,

                                    );
                                    if (!mounted) return;
                                    print(resultingDuration);

                                    if (resultingDuration != null) {
                                      List<String> parts = resultingDuration
                                          .toString()
                                          .split(":");
                                      String hours = parts[0].padLeft(2, '0');
                                      String minutes = parts[1];
                                      hoursController.text = hours;
                                      minutesController.text = minutes;
                                      model.setDuration(
                                          int.parse(hours), int.parse(minutes));
                                    }
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          10), // Adjust the value as needed
                                    ),
                                    // padding: const EdgeInsets.symmetric(horizontal: 24.0),

                                    elevation: 3,
                                    primary: theme
                                        .primaryColorLight, // Background color of the button
                                  ),
                                  child: Icon(Icons.hourglass_bottom)),
                              content: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.07,
                                width: MediaQuery.of(context).size.width * 0.6,
                                alignment: Alignment.center,
                                child: Text(
                                  Strings.durationTooltip,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.08,
                          bottom: 70),
                      child: SharedButton(
                        buttonLabel:
                            widget.edit ? Strings.editTask : Strings.addTask,
                        onClick: () async {
                          if (widget.edit) {
                            var success = await model.editTask(
                                widget.taskObj,
                                descController.text.isEmpty
                                    ? widget.taskObj.desc!
                                    : descController.text);
                            if (success) {
                              SnackbarShare.showMessage(
                                  Strings.doneEdits);
                              Navigator.pop(context, true);
                            } else {
                              SnackbarShare.showMessage(
                                  Strings.systemError);
                            }
                          } else {
                            if (hoursController.text.isEmpty ||
                                minutesController.text.isEmpty ||
                                descController.text.isEmpty) {
                              SnackbarShare.showMessage(
                                  Strings.emptyField);
                            } else {
                              model.setDuration(int.parse(hoursController.text),
                                  int.parse(minutesController.text));
                              var success =
                                  await model.addTask(descController.text);
                              if (success) {
                                hoursController.clear();
                                minutesController.clear();
                                descController.clear();
                                SnackbarShare.showMessage(
                                    Strings.doneAdd);
                              } else {
                                SnackbarShare.showMessage(
                                    Strings.systemError);
                              }
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 20, left: 20),
                child: Divider(),
              ),
            ],
          ),
        ));
  }
}

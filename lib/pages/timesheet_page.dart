import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rive/rive.dart';
import 'package:thakafah_reports/shared_widget/snackbar.dart';
import '../constant/app_strings.dart';
import '../core/model/report_details.dart';
import '../core/viewModels/timesheet_vmodel.dart';
import '../core/viewstate.dart';
import '../shared_widget/button_widget.dart';
import 'base_view.dart';

class TimeSheetPage extends StatefulWidget {
  const TimeSheetPage({Key? key}) : super(key: key);

  @override
  State<TimeSheetPage> createState() => _TimeSheetPageState();
}

class _TimeSheetPageState extends State<TimeSheetPage> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return BaseView<TimesheetVModel>(
        onModelReady: (model) => model.getDetailsTask(),
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

  @override
  void initState() {
    SnackbarShare.init(context);
    super.initState();
  }

  Widget mainWidget(TimesheetVModel model, ThemeData theme) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(
                    20,
                  ),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.1,
                          child: Align(
                            alignment: Alignment.topRight,
                            child: DropdownButton<int>(
                              value: model.selectedMonth,
                              icon: const Icon(Icons.arrow_drop_down_rounded),
                              elevation: 16,
                              alignment: Alignment.topRight,
                              style: theme.textTheme.titleLarge,
                              onChanged: (int? value) {
                                model.setMonth(value!);
                                model.getDetailsTask();
                              },
                              items: model.monthList
                                  .map<DropdownMenuItem<int>>((int value) {
                                return DropdownMenuItem<int>(
                                  value: value,
                                  child: Center(
                                    child: Text(
                                      value.toString(),
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
                          )),
                      Text(
                       Strings.timesheetSubject,
                        textDirection: TextDirection.rtl,
                        style: theme.textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Divider(),
                ),
                Padding(
                    padding: const EdgeInsets.only(
                        top: 15, left: 15, right: 15, bottom: 70),
                    child: model.detailsObj.reportLine != null?ExpansionPanelList(
                        elevation: 2,
                        expansionCallback: (int index, bool isExpanded) {
                          setState(() {
                            model.detailsObj.reportLine![index].isExpanded =
                                !model
                                    .detailsObj.reportLine![index].isExpanded!;
                          });
                        },
                        children: model.detailsObj.reportLine!
                                .map<ExpansionPanel>((ReportLine task) {
                                final int index =
                                    model.detailsObj.reportLine!.indexOf(task);

                                var durationSum = 0.0;

                                for (var i in task.taskInfo!) {
                                  durationSum += i.taskDuration!;
                                }

                                return ExpansionPanel(
                                  canTapOnHeader: true,
                                  headerBuilder:
                                      (BuildContext context, bool isExpanded) {
                                    return ListTile(
                                      title: Text(
                                        task.date!,
                                        style: theme.textTheme.bodyLarge,
                                        textAlign: TextAlign.center,
                                      ),
                                      leading: Text(
                                        task.dayOff!
                                            ? Strings.dayOff
                                            : model.durationInTime(durationSum),
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: task.dayOff!
                                                ? Colors.black
                                                : durationSum >= 8
                                                    ? Colors.green
                                                    :durationSum==0?Colors.red: Colors.yellow[700]),
                                        textAlign: TextAlign.center,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ), // Adjust the values as needed
                                    );
                                  },
                                  body: ListTile(
                                    title: SizedBox(
                                      height: (task.taskInfo!.isEmpty ||
                                              task.dayOff!)
                                          ? MediaQuery.of(context).size.height *
                                              0.08
                                          : MediaQuery.of(context).size.height *
                                              0.2,
                                      child: task.dayOff!
                                          ? Text(
                                             Strings.dayOffLabel,
                                              textAlign: TextAlign.center,
                                            )
                                          : task.taskInfo!.isNotEmpty
                                              ? ListView.builder(
                                                  itemCount: task.taskInfo!.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int i) {
                                                    TaskInfo info = model
                                                        .detailsObj
                                                        .reportLine![index]
                                                        .taskInfo![i];

                                                    return Column(
                                                      children: [
                                                        task.leave!>0.0 ?
                                                        taskInfoItem(
                                                            Strings.leave,
                                                            model.durationInTime(
                                                                task.leave!),
                                                            theme):SizedBox(),
                                                        task.leave!>0.0 ? Divider():SizedBox(),
                                                        taskInfoItem(
                                                            info.taskTitle!,
                                                            model.durationInTime(
                                                                info.taskDuration!),
                                                            theme),
                                                        i < task.taskInfo!.length - 1
                                                            ? Divider()
                                                            : SizedBox(),
                                                      ],
                                                    );
                                                  },
                                                )
                                              : Column(
                                                children: [
                                                  task.leave!>0.0 ?taskInfoItem(
                                                      Strings.leave,
                                                      model.durationInTime(
                                                          task.leave!),
                                                      theme):SizedBox(),
                                                  task.leave!>0.0 ? Divider():SizedBox(),
                                                  Text(
                                                      Strings.noTaskAdded,
                                                      textAlign: TextAlign.center,
                                                    ),
                                                ],
                                              ),
                                    ),
                                  ),
                                  isExpanded: model.detailsObj
                                      .reportLine![index].isExpanded!,
                                );
                              }).toList()
                         ):Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 70),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: RiveAnimation.asset(
                          'assets/riv/empty_task.riv',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      child: Text(
                       Strings.timesheetEmpty,
                        style: theme.textTheme.displayMedium,
                      ),
                    ),
                  ],
                )),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.13,
                )
              ],
            ),
          ),
        ),
        model.detailsObj.reportLine != null?   Align(
          alignment: Alignment.bottomRight,
          child: Container(
            decoration: BoxDecoration(
              color:
                  model.visibleReportDetails ? Colors.white : theme.hintColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            height: model.visibleReportDetails
                ? MediaQuery.of(context).size.height * 0.45
                : MediaQuery.of(context).size.height * 0.07,
            width: model.visibleReportDetails
                ? double.maxFinite
                : MediaQuery.of(context).size.width * 0.25,
            child:

            model.visibleReportDetails
                ? Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20, right: 20, bottom: 20),
                        child: GestureDetector(
                            onTap: () {
                              model.setVisibleDetails(false);
                            },
                            child: Icon(
                              Icons.close,
                              size: 19,
                            )),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(
                              top: 50, bottom: 10, right: 15, left: 15),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            durationText(
                                                model,
                                                model.detailsObj
                                                    .mainExpectedHourInMonth!,
                                                model.detailsObj
                                                    .doneMainHourInMonth!,
                                                true),
                                            titleWidget(Strings.doneHours),
                                          ],
                                        ),
                                        Divider(),
                                        Row(
                                          children: [
                                            durationText(
                                                model,
                                                model.detailsObj
                                                    .overtimeExpectedHourInMonth!,
                                                model.detailsObj
                                                    .doneOvertimeHourInMonth!,
                                                true),
                                            titleWidget(
                                               Strings.doneOverTimeHours),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Align(
                                      alignment: Alignment.topCenter,
                                      child: SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.1,
                                          child: VerticalDivider())),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            durationText(
                                                model,
                                                model.detailsObj
                                                    .mainExpectedHourInMonth!,
                                                0.0,
                                                false),
                                            titleWidget(Strings.expectedHours),
                                          ],
                                        ),
                                        Divider(),
                                        Row(
                                          children: [
                                            durationText(
                                                model,
                                                model.detailsObj
                                                    .overtimeExpectedHourInMonth!,
                                                0.0,
                                                false),
                                            titleWidget(
                                                Strings.expectedOverTimeHours),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Divider(),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.11,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          leaveValueWidget(model
                                              .detailsObj.totalLeave!
                                              .toString()),
                                          titleWidget(
                                              Strings.leaveHours),
                                        ],
                                      ),
                                    ),
                                    VerticalDivider(),
                                    Expanded(
                                        child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              leaveValueWidget(model
                                                  .detailsObj.normalDaysOff!
                                                  .toString()),
                                              titleWidget(
                                                 Strings.numOfNormalDayOff),
                                            ],
                                          ),
                                        ),
                                        Divider(),
                                        Expanded(
                                            child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            leaveValueWidget(model
                                                .detailsObj.sicknessDaysOff!
                                                .toString()),
                                            titleWidget(
                                               Strings.numOfSickDayOff),
                                          ],
                                        )),
                                      ],
                                    )),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: SharedButton(
                                  buttonLabel: Strings.confirmSheet,
                                  onClick: () async {
                                    if (model.detailsObj.totalHoursShortage! >
                                        0.0) {
                                      // set up the button
                                      Widget okButton = TextButton(
                                        child: Text(Strings.confirmSheet,),
                                        onPressed: () async {
                                          var success =
                                              await model.confirmSheet();
                                          if (success) {
                                            SnackbarShare.showMessage(
                                              Strings.sheetConfirmed);
                                          } else {
                                            SnackbarShare.showMessage(
                                                Strings.systemError);
                                          }
                                          Navigator.pop(context);
                                        },
                                      );
                                      Widget cancelButton = TextButton(
                                        child: Text(Strings.cancel),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      );
                                      // set up the AlertDialog
                                      AlertDialog alert = AlertDialog(
                                        title: Text(
                                          Strings.attention,
                                          textAlign: TextAlign.right,
                                        ),
                                        content: Text(
                                          " نقص ساعاتك ${model.detailsObj.totalHoursShortage!}",
                                          textAlign: TextAlign.right,
                                        ),
                                        actions: [
                                          cancelButton,
                                          okButton,
                                        ],
                                      );

                                      // show the dialog
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return alert;
                                        },
                                      );

                                      // SnackbarShare.showMessage(
                                      //     "يرجى الانتباه أن نقص ساعاتك ${model.detailsObj.totalHoursShortage!}");
                                    }
                                  },
                                ),
                              )
                            ],
                          )),
                    ],
                  )
                : GestureDetector(
                    onTap: () {
                      model.setVisibleDetails(true);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          Strings.details,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyLarge,
                        ),
                        Icon(
                          Icons.arrow_drop_down_rounded,
                          size: 20,
                        )
                      ],
                    )),
          ),
        ):SizedBox(),
      ],
    );
  }

  Widget taskInfoItem(String title, String duration, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(
          children: [
            Text(
              duration,
              style: theme.textTheme.bodyLarge,
              textDirection: TextDirection.rtl,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Icon(
                Icons.hourglass_bottom,
                size: 16,
                color: theme.primaryColor,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              title.length > 15 ? '${title.substring(0, 15)}...' : title,
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Icon(
                Icons.task,
                size: 16,
                color: theme.primaryColor,
              ),
            ),
          ],
        ),
      ]),
    );
  }

  String getTimeStringFromDouble(double value) {
    if (value < 0) return 'Invalid Value';
    int flooredValue = value.floor();
    double decimalValue = value - flooredValue;
    String hourValue = getHourString(flooredValue);
    String minuteString = getMinuteString(decimalValue);

    return '$hourValue:$minuteString';
  }

  String getMinuteString(double decimalValue) {
    return '${(decimalValue * 60).toInt()}'.padLeft(2, '0');
  }

  String getHourString(int flooredValue) {
    return '${flooredValue % 24}'.padLeft(2, '0');
  }

  Widget durationText(TimesheetVModel model, double durationTime,
      double doneDuration, bool isDone) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.14,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(width: 1),
          borderRadius: BorderRadius.all(
              Radius.circular(5.0) //                 <--- border radius here
              ),
        ),
        //             <--- BoxDecoration here
        child: Text(
          model.durationInTime(
            isDone ? doneDuration : durationTime,
          ),
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDone
                  ? doneDuration < durationTime
                      ? Colors.red
                      : Colors.green
                  : Colors.black),
        ));
  }

  Widget titleWidget(String title) {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.045,
        width: MediaQuery.of(context).size.width * 0.3,
        child: Text(
          title,
          textAlign: TextAlign.right,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ));
  }

  Widget leaveValueWidget(String text) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.13,
        height: MediaQuery.of(context).size.height * 0.03,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(width: 1),
          borderRadius: BorderRadius.all(
              Radius.circular(5.0) //                 <--- border radius here
              ),
        ),
        //             <--- BoxDecoration here
        child: Text(
          text,
          style: TextStyle(fontWeight: FontWeight.bold),
        ));
  }
}

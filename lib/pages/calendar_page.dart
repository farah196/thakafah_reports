
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rive/rive.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:thakafah_reports/core/model/task_model.dart';
import 'package:thakafah_reports/core/viewModels/calendar_model.dart';
import 'package:thakafah_reports/pages/add_task_page.dart';
import 'package:thakafah_reports/shared_widget/app_theme.dart';
import 'package:thakafah_reports/shared_widget/snackbar.dart';

import '../core/services/timesheet_prefrence.dart';
import '../core/viewstate.dart';
import 'base_view.dart';
import 'main_page.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  var _calendarFormat = CalendarFormat.month;
  final tooltipController = JustTheController();



  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return BaseView<CalendarModel>(
        onModelReady: (model) => model.getTitle(),
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

  Widget mainWidget(CalendarModel model, ThemeData theme) {
    TimeSheetPreference.getShowTaskItem().then((value) {
      if (value == true && model.tasks.isNotEmpty) {
        Future.delayed(const Duration(seconds: 1), () {
          tooltipController.showTooltip(immediately: false);
        });
        tooltipController.addListener(() {
          // Prints the enum value of [TooltipStatus.isShowing] or [TooltipStatus.isHiding]
          print('controller: ${tooltipController.value}');
        });
      }
    });
    return Column(
      children: [
        TableCalendar<String>(
          firstDay: DateTime.utc(1990, 01, 01),
          lastDay: DateTime.utc(2222, 01, 01),
          focusedDay: model.focusedDay,
          selectedDayPredicate: (day) => isSameDay(selectedDay, day),
          calendarFormat: _calendarFormat,
          eventLoader: (day) {
            return [];
            // if(focusedDay == day){
            //   return model.fillEvent(controller.index);
            // }else{
            //   return [] ;
            // }
          },
          locale: Localizations.localeOf(context).languageCode,
          startingDayOfWeek: StartingDayOfWeek.sunday,
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: theme.hintColor,
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: theme.primaryColor,
              shape: BoxShape.circle,
            ),
            markerDecoration: const BoxDecoration(
              color: Colors.black12,
              shape: BoxShape.circle,
            ),
            markerSize: 8,
            markersMaxCount: 3,
            markerMargin: const EdgeInsets.only(top: 12, right: 4),
          ),
          onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
            model.onDaySelected(selectedDay, focusedDay);
          },
          onFormatChanged: (format) {
            if (_calendarFormat != format) {
              setState(() {
                _calendarFormat = format;
              });
            }
          },
          // onPageChanged: (day) {
          //   setState(() {
          //     model.focusedDay = day;
          //   });
          // },
        ),
        const SizedBox(height: 8.0),
        const Divider(),
        Expanded(flex: 3, child: activityOnThisDay(theme, model)),
      ],
    );
  }

  Widget activityOnThisDay(ThemeData theme, CalendarModel model) {
    List colors = [
      AppTheme.category1,
      AppTheme.category2,
      AppTheme.category3,
      AppTheme.category4,
      AppTheme.category5,
    ];

    if (model.tasks.isNotEmpty) {
      return Column(
        children: [
          SizedBox(
            child: Padding(
              padding: const EdgeInsets.only(right: 15, top: 10, bottom: 10),
              child: Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    "مهام اليوم",
                    style: theme.textTheme.displayLarge,
                  )),
            ),
          ),
          Expanded(
            flex: 6,
            child: ListView.builder(
              itemCount: model.tasks.length,
              itemBuilder: (context, index) {
                int colorIndex = index % colors.length;
                Color itemColor = colors[colorIndex];

                return Column(
                  children: [

                    index == 0
                        ? JustTheTooltip(
                            controller: tooltipController,
                            onDismiss: () {
                              TimeSheetPreference.setShowTaskItem(false);
                            },
                            content: Container(
                              padding: EdgeInsets.only(top: 15,left: 10,right: 10),
                              height: MediaQuery.of(context).size.height*0.09,
                              width: MediaQuery.of(context).size.width*0.6,

                              child: Text(
                                'اذا أردت تعديل المهام قم بتمريره الى اليمين واذا أردت حذفه قم بتمريره الى اليسار ',
                                textAlign: TextAlign.center,
                                textDirection: TextDirection.rtl,
                              ),
                            ),
                            child: returnTask(theme, model, index, itemColor))
                        : returnTask(theme, model, index, itemColor),


                    index != model.tasks.length - 1
                        ? const Padding(
                            padding: EdgeInsets.only(left: 30, right: 30),
                            child: Divider(),
                          )
                        : const Padding(padding: EdgeInsets.only(bottom: 70))
                  ],
                );
              },
            ),
          ),
        ],
      );
    } else {
      ;
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width * 0.5,
            child: RiveAnimation.asset(
              'assets/riv/empty_task.riv',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            child: Text(
              "لا يوجد اي مهام مضاف",
              style: theme.textTheme.displayMedium,
            ),
          ),
        ],
      );
    }
  }

  Widget returnTask(
      ThemeData theme, CalendarModel model, int index, Color color) {
    String title = model.returnTitleFromID(model.tasks[index].titleId!);
    double duration = model.tasks[index].duration!;
    String formattedDuration = duration
        .toStringAsFixed(2); // Converts to a string with 2 decimal places
    if (formattedDuration.endsWith('.00')) {
      formattedDuration = formattedDuration.substring(
          0, formattedDuration.length - 3); // Remove trailing '.00'
    }

    return Container(
        height: MediaQuery.of(context).size.height * 0.1,
        margin: const EdgeInsets.only(left: 20, right: 20, top: 2, bottom: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: theme.hintColor.withOpacity(0.5),
          boxShadow: [
            BoxShadow(
              blurRadius: 1,
              color: Colors.white.withOpacity(.1),
            )
          ],
        ),
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.06,
              width: MediaQuery.of(context).size.width * 0.14,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
                color: color,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "المدة",
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    formattedDuration,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Slidable(
              key: Key('anyString'),
              startActionPane: ActionPane(
                motion: const ScrollMotion(),

                // dismissible: DismissiblePane(
                //
                //     key: Key('anyString'),
                //     onDismissed: () async {
                //       var success = await model.deleteTask(
                //           model.tasks[index].taskId!, index);
                //       if (success) {
                //         SnackbarShare.showMessage("تم حذفها بنجاح");
                //       } else {
                //         SnackbarShare.showMessage(
                //             "حدث خطأ ، يرجى المحاولة مرة أخرى");
                //       }
                //     },
                //     ),
                children: [
                  SlidableAction(
                    onPressed: (BuildContext context) async {
                      var success = await model.deleteTask(
                          model.tasks[index].taskId!, index);
                      if (success) {
                        SnackbarShare.showMessage("تم حذفها بنجاح");
                      } else {
                        SnackbarShare.showMessage(
                            "حدث خطأ ، يرجى المحاولة مرة أخرى");
                      }
                    },
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10)),
                    label: 'حذف',
                  ),
                ],
              ),
              endActionPane: ActionPane(
                motion: const ScrollMotion(),

                children: [
                  SlidableAction(
                    padding: const EdgeInsets.all(0),
                    onPressed: (BuildContext context) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => AddTaskPage(
                                  edit: true,
                                  taskObj: model.tasks[index],
                                )),
                      ).then((value) {
                        if (value != null && value == true) {
                          model.getTask();
                        }
                      });
                    },
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    label: 'تعديل',
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // GestureDetector(
                  //     onTap: () {
                  //       // Navigator.push(
                  //       //   context,
                  //       //   MaterialPageRoute(
                  //       //       builder: (BuildContext context) => EventDetails(
                  //       //         model: events[index],
                  //       //       )),
                  //       // );
                  //     },
                  //     child: Container(
                  //         padding: const EdgeInsets.all(3),
                  //         margin: const EdgeInsets.only(left: 15),
                  //         decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(5),
                  //             border: Border.all(
                  //               color: theme.hintColor,
                  //             )),
                  //         child: Row(
                  //           children: [
                  //             Icon(
                  //               Icons.arrow_back_ios,
                  //               color: theme.hintColor,
                  //               size: 16,
                  //             ),
                  //             Text(
                  //               "المزيد",
                  //               style: theme.textTheme.bodyMedium,
                  //             ),
                  //           ],
                  //         ))),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, right: 10),
                    child: Align(
                        alignment: Alignment.topRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              title,
                              style: theme.textTheme.displayMedium,
                              textDirection: TextDirection.rtl,
                            ),
                            Text(
                              " # ",
                              style: TextStyle(color: color, fontSize: 23),
                              textDirection: TextDirection.rtl,
                            ),
                          ],
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 25, bottom: 10),
                    child: Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          model.tasks[index].desc!,
                          style: theme.textTheme.bodyMedium,
                          textDirection: TextDirection.rtl,
                        )),
                  ),
                  // Column(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: [
                  //     Align(
                  //         alignment: Alignment.topRight,
                  //         child: Text(
                  //           events[index].toString(),
                  //           style: theme.textTheme.displayMedium,
                  //         )),
                  //
                  //   ],
                  // ),
                ],
              ),
            ),
          ],
        ));
  }

  editFunc(BuildContext context, Task taskObj) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => AddTaskPage(
                edit: true,
                taskObj: taskObj,
              )),
    );
  }


}

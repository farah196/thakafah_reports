import 'package:day_night_time_picker/lib/constants.dart';
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rive/rive.dart';
import 'package:thakafah_reports/core/model/leaves_model.dart';
import 'package:thakafah_reports/core/viewModels/leave_vmodel.dart';
import '../constant/app_strings.dart';
import '../core/model/leave_model.dart';
import '../core/model/leaves_type.dart';
import '../core/model/title_model.dart';
import '../core/viewstate.dart';
import '../shared_widget/app_theme.dart';
import '../shared_widget/button_widget.dart';
import '../shared_widget/snackbar.dart';
import '../shared_widget/text_field_widget.dart';
import 'base_view.dart';

class LeavePage extends StatefulWidget {
  const LeavePage({Key? key}) : super(key: key);

  @override
  State<LeavePage> createState() => _LeavePageState();
}

class _LeavePageState extends State<LeavePage>
    with SingleTickerProviderStateMixin {
  String selectedReason = "";
  List<String> reasons = ["", Strings.sickReason, Strings.normalReason];
  var selectedDate = "";
  var returnDate = "";
  TextEditingController dayOffReasonController = TextEditingController();
  TextEditingController leaveReasonController = TextEditingController();
  TextEditingController hoursController = TextEditingController();
  TextEditingController minutesController = TextEditingController();

  @override
  void initState() {
    SnackbarShare.init(context);
    super.initState();
  }

  @override
  void dispose() {
    leaveReasonController.dispose();
    dayOffReasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return BaseView<LeaveVModel>(
        onModelReady: (model) => model.getLeaveType(),
        builder: (context, model, child) {
          return mainWidget(model, theme);
        });
  }

  Widget mainWidget(LeaveVModel model, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10, top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    addLeave(model, theme);
                  },
                  child: Icon(Icons.add, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(7),
                    backgroundColor: theme.primaryColor,
                    foregroundColor: theme.primaryColorLight,
                  ),
                ),
                Text(
                  Strings.requestLeaveSubject,
                  textDirection: TextDirection.rtl,
                  style: theme.textTheme.titleLarge,
                ),
              ],
            ),
          ),
          Directionality(
            textDirection: TextDirection.rtl,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.19,
              child: ListView.builder(
                itemCount: model.leaveTypes.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (ctx, i) {
                  return balanceWidget(
                      model.leaveTypes[i].name!,
                      model.leaveTypes[i].virtualRemainingLeaves!
                          .toInt()
                          .toString());
                },
              ),
            ),
          ),
          Divider(
            color: Colors.grey[100],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.065,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          final picked = await showDateRangePicker(
                            context: context,
                            lastDate: DateTime(2060),
                            firstDate: new DateTime(2022),
                            currentDate: DateTime.now(),
                          );
                          if (picked != null && picked != null) {
                            print(picked);
                            model.updateStartFormattedDate(picked.start);
                            model.updateEndFormattedDate(picked.end);
                            model.getLeaves();
                          }
                        },
                        icon: Icon(Icons.calendar_month_outlined),
                      ),
                      PopupMenuButton<TitleM>(
                          icon: Icon(Icons.sort_rounded),
                          onSelected: (value) {
                            model.getLeaves();
                            Navigator.pop(context);
                          },
                          itemBuilder: (BuildContext context) {
                            return model.statusLeave.map((TitleM item) {
                              return PopupMenuItem<TitleM>(
                                child: GestureDetector(
                                  onTap: () {
                                    model.setSelectedStatus(item);
                                    model.getLeaves();
                                    Navigator.pop(context);
                                  },
                                  child: ListTile(
                                    title: Text(item.name.toString()),
                                  ),
                                ),
                              );
                            }).toList();
                          }),
                    ],
                  ),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.65,
                      child: ListView.builder(
                        itemCount: model.leaveTypes.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (ctx, i) {
                          return GestureDetector(
                              onTap: () {
                                if (model.selectedType.id ==
                                    model.leaveTypes[i].id) {
                                  model.setSelectedType(TypeL(id: 0, name: ""));
                                } else {
                                  model.setSelectedType(model.leaveTypes[i]);
                                }
                                model.getLeaves();
                              },
                              child: filterItem(
                                  model.leaveTypes[i].name!,
                                  model.selectedType.id ==
                                      model.leaveTypes[i].id));
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15, top: 5),
            child: Align(
              alignment: Alignment.topRight,
              child: Text(
                model.selectDate
                    ? "${model.startFormattedDate.toString()} | ${model.endFormattedDate.toString()}"
                    : "",
                style: theme.textTheme.titleMedium,
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: model.state == ViewState.busy
                ? LoadingAnimationWidget.fourRotatingDots(
                    color: theme.primaryColor,
                    size: 30,
                  )
                : model.leaves.isNotEmpty
                    ? listOfDaysOff(theme, model)
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.2,
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: RiveAnimation.network(
                              "https://public.rive.app/community/runtime-files/441-812-magnifier-animation-for-search-bars.riv",
                            ),
                          ),
                          Text(
                            "لا يوجد أي إجازة مضافة",
                            style: theme.textTheme.titleMedium,
                          ),
                        ],
                      ),
          )
        ],
      ),
    );
  }

  Widget listOfDaysOff(ThemeData theme, LeaveVModel model) {
    List colors = [
      AppTheme.category1,
      AppTheme.category2,
      AppTheme.category3,
      AppTheme.category4,
      AppTheme.category5,
    ];
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3,
      width: double.maxFinite,
      child: ListView.builder(
        itemCount: model.leaves.length,
        itemBuilder: (context, index) {
          int colorIndex = index % colors.length;
          Color itemColor = colors[colorIndex];
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: model.selectDate == 0 ? 10 : 0),
                child: returnTask(theme, model.leaves[index], itemColor, model),
              ),
              index != model.leaves.length - 1
                  ? Padding(
                      padding: EdgeInsets.only(left: 30, right: 30, bottom: 5),
                    )
                  : const Padding(padding: EdgeInsets.only(bottom: 70))
            ],
          );
        },
      ),
    );
  }

  Widget returnTask(
      ThemeData theme, Data data, Color color, LeaveVModel model) {
    double leaveDuration = 0;

    if (data.holidayTypeId == 11) {
      double to = double.parse(data.requestHourTo.toString());
      double from = double.parse(data.requestHourFrom.toString());
      leaveDuration = to - from;
    }

    return Container(
        height: MediaQuery.of(context).size.height * 0.145,
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
                    Strings.durationKey,
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    data.holidayTypeId == 11
                        ? leaveDuration.toString()
                        : data.duration.toString().split(" ").first,
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
                children: [
                  SlidableAction(
                    onPressed: (BuildContext context) async {},
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
                    onPressed: (BuildContext context) {},
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    label: Strings.edit,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 15, right: 10, bottom: 10),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        data.holidayStatusId.toString(),
                        style: theme.textTheme.displayMedium,
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 25, bottom: 5),
                    child: Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          data.name.toString().length > 40
                              ? '${data.name.toString().substring(0, 40)}...'
                              : data.name.toString(),
                          style: theme.textTheme.bodyMedium,
                          textDirection: TextDirection.rtl,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 25, left: 25),
                    child: Divider(
                      color: Colors.grey,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 25,
                      bottom: 5,
                      left: 25,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          model
                              .getLeaveStatus(data.state.toString())
                              .name
                              .toString(),
                          style: TextStyle(
                              color: model
                                  .getLeaveStatus(data.state.toString())
                                  .color,fontSize: 13,fontWeight: FontWeight.bold),
                          textDirection: TextDirection.rtl,
                        ),
                        Row(
                          children: [
                            Text(
                              "|${data.requestDateTo.toString().split("-")[1]}-${data.requestDateTo.toString().split("-").last}",
                              style: theme.textTheme.bodyMedium,
                              textDirection: TextDirection.rtl,
                            ),
                            Text(
                              "${data.requestDateFrom.toString().split("-")[1]}-${data.requestDateFrom.toString().split("-").last}",
                              style: theme.textTheme.bodyMedium,
                              textDirection: TextDirection.rtl,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  addLeave(LeaveVModel model, ThemeData theme) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return FractionallySizedBox(
                heightFactor: 0.8,
                child: Scaffold(
                    resizeToAvoidBottomInset: false,
                    body: Column(
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(
                                top: 10, bottom: 10, right: 20, left: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () {
                                    leaveReasonController.text = "";
                                    model.updateStartFormattedDate(
                                        DateTime.now());
                                    model
                                        .updateEndFormattedDate(DateTime.now());
                                    Navigator.pop(context);
                                  },
                                ),
                                Text(
                                  "إضافة إجازة",
                                  style: theme.textTheme.displayMedium,
                                ),
                              ],
                            )),
                        Padding(
                            padding: const EdgeInsets.only(
                                top: 10, right: 30, left: 30),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: DropdownButton<TypeL>(
                                      value: model.selectedTypeSheet,
                                      icon: const Icon(
                                          Icons.arrow_drop_down_rounded),
                                      elevation: 16,
                                      style: TextStyle(color: Colors.black38),
                                      onChanged: (TypeL? value) {
                                        setState(() {
                                          model.setSelectedTypeSheet(value!);
                                        });
                                      },
                                      items: model.leaveTypes
                                          .map<DropdownMenuItem<TypeL>>(
                                              (TypeL value) {
                                        return DropdownMenuItem<TypeL>(
                                          value: value,
                                          child: Center(
                                            child: Text(
                                              value.name!,
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  fontFamily: "Tajawal",
                                                  color: Colors.black),
                                              textAlign: TextAlign.right,
                                              textDirection: TextDirection.rtl,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    child: Text(
                                      Strings.typeOfDayOff,
                                      style: theme.textTheme.bodyLarge,
                                      textAlign: TextAlign.right,
                                      textDirection: TextDirection.rtl,
                                    ),
                                  ),
                                ])),
                        Padding(
                            padding: const EdgeInsets.only(
                                top: 10, right: 30, left: 30),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    outLineButton(
                                      () async {
                                        DateTime? pickedDate = await showDatePicker(
                                            context: context,
                                            builder: (context, child) {
                                              return Theme(
                                                data:
                                                    Theme.of(context).copyWith(
                                                  colorScheme:
                                                      ColorScheme.light(
                                                    primary:
                                                        theme.primaryColorLight,
                                                    // header background color
                                                    onPrimary: Colors.white,
                                                    // header text color
                                                    onSurface: Colors
                                                        .black, // body text color
                                                  ),
                                                  textButtonTheme:
                                                      TextButtonThemeData(
                                                    style: TextButton.styleFrom(
                                                      primary: Colors
                                                          .black, // button text color
                                                    ),
                                                  ),
                                                ),
                                                child: child!,
                                              );
                                            },
                                            cancelText: Strings.cancel,
                                            initialDate: DateTime.now(),
                                            //get today's date
                                            firstDate: DateTime(2000),
                                            //DateTime.now() - not to allow to choose before today.
                                            lastDate: DateTime(2101));

                                        if (pickedDate != null) {
                                          setState(() {
                                            model.updateStartFormattedDate(
                                                pickedDate);
                                          });
                                        }
                                      },
                                      theme,
                                      model.startFormattedDate,
                                    ),
                                    Text(
                                      model.selectedTypeSheet.id == 11
                                          ? Strings.dateOfLeave
                                          : Strings.dateOfDayOff,
                                      style: theme.textTheme.bodyLarge,
                                      textDirection: TextDirection.rtl,
                                    ),
                                  ],
                                ),
                                model.selectedTypeSheet.id == 11
                                    ? SizedBox()
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          outLineButton(
                                            () async {
                                              DateTime? pickedDate =
                                                  await showDatePicker(
                                                      context: context,
                                                      builder:
                                                          (context, child) {
                                                        return Theme(
                                                          data:
                                                              Theme.of(context)
                                                                  .copyWith(
                                                            colorScheme:
                                                                ColorScheme
                                                                    .light(
                                                              primary: theme
                                                                  .primaryColorLight,
                                                              // header background color
                                                              onPrimary:
                                                                  Colors.white,
                                                              // header text color
                                                              onSurface: Colors
                                                                  .black, // body text color
                                                            ),
                                                            textButtonTheme:
                                                                TextButtonThemeData(
                                                              style: TextButton
                                                                  .styleFrom(
                                                                primary: Colors
                                                                    .black, // button text color
                                                              ),
                                                            ),
                                                          ),
                                                          child: child!,
                                                        );
                                                      },
                                                      cancelText:
                                                          Strings.cancel,
                                                      initialDate:
                                                          DateTime.now(),
                                                      //get today's date
                                                      firstDate: DateTime(2000),
                                                      //DateTime.now() - not to allow to choose before today.
                                                      lastDate: DateTime(2101));

                                              if (pickedDate != null) {
                                                setState(() {
                                                  model.updateEndFormattedDate(
                                                      pickedDate);
                                                });
                                              }
                                            },
                                            theme,
                                            model.endFormattedDate,
                                          ),
                                          Text(
                                            Strings.endDateOfDayOff,
                                            style: theme.textTheme.bodyLarge,
                                            textDirection: TextDirection.rtl,
                                          ),
                                        ],
                                      )
                              ],
                            )),
                        model.selectedTypeSheet.id == 11
                            ? Padding(
                                padding: const EdgeInsets.only(
                                    top: 10, right: 30, left: 30),
                                child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          outLineButton(() async {
                                            Navigator.of(context)
                                                .push(showPicker(
                                              okStyle:
                                                  theme.textTheme.titleMedium!,
                                              okText: Strings.startLeave,
                                              disableAutoFocusToNextInput: true,
                                              showSecondSelector: false,
                                              elevation: 1,
                                              showCancelButton: false,
                                              minuteInterval:
                                                  TimePickerInterval.THIRTY,
                                              value: model.startHour,
                                              is24HrFormat: true,
                                              onChange: (Time time) {
                                                setState(() {
                                                  var t = time.minute == 59
                                                      ? Time(
                                                          hour: time.hour,
                                                          minute: 00)
                                                      : time;
                                                  model.setStartHour(t);
                                                });
                                              },
                                            ));
                                          },
                                              theme,
                                              model.startHour.hour < 10
                                                  ? "0${model.startHour.hour}:${model.startHour.minute == 0 ? "0${model.startHour.minute.toString()}" : model.startHour.minute.toString()}"
                                                  : "${model.startHour.hour.toString()}:${model.endHour.minute == 0 ? "0${model.endHour.minute.toString()}" : model.endHour.minute.toString()}"),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.3,
                                            child: Text(
                                              "# من الساعة",
                                              style: theme.textTheme.bodyLarge,
                                              textDirection: TextDirection.rtl,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          outLineButton(() async {
                                            Navigator.of(context)
                                                .push(showPicker(
                                              okStyle:
                                                  theme.textTheme.titleMedium!,
                                              okText: Strings.endLeave,
                                              disableAutoFocusToNextInput: true,
                                              showSecondSelector: false,
                                              elevation: 1,
                                              showCancelButton: false,
                                              value: model.endHour,
                                              onChange: (Time time) {
                                                setState(() {
                                                  var t = time.minute == 59 ||
                                                          time.minute == 0
                                                      ? Time(
                                                          hour: time.hour,
                                                          minute: 00)
                                                      : time;
                                                  model.setEndHour(t);
                                                });
                                              },
                                              minuteInterval:
                                                  TimePickerInterval.THIRTY,
                                              is24HrFormat: true,
                                            ));
                                          },
                                              theme,
                                              model.endHour.hour < 10
                                                  ? "0${model.endHour.hour}:${model.endHour.minute == 0 ? "0${model.endHour.minute.toString()}" : model.endHour.minute.toString()}"
                                                  : "${model.endHour.hour.toString()}:${model.endHour.minute == 0 ? "0${model.endHour.minute.toString()}" : model.endHour.minute.toString()}"),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.3,
                                            child: Text(
                                              "# الى الساعة",
                                              style: theme.textTheme.bodyLarge,
                                              textDirection: TextDirection.rtl,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ]))
                            : SizedBox(),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10, right: 30, left: 30),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              model.selectedTypeSheet.id == 11
                                  ? Strings.reasonLeave
                                  : Strings.reasonOfDayOff,
                              style: theme.textTheme.bodyLarge,
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 15, right: 30, left: 30),
                          child: SharedEditText(
                            textEditingController: dayOffReasonController,
                            label: "",
                            line: 3,
                            icon: const Icon(
                              Icons.description,
                              size: 20,
                            ),
                            onChange: () {
                              // model.setError(false);
                            },
                            onSubmit: () {
                              // model.setError(false);
                            },
                            isObscureText: false,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.08,
                              bottom: 70),
                          child: SharedButton(
                            buttonLabel: model.selectedTypeSheet.id == 11
                                ? Strings.confirmLeave
                                : Strings.confirmDayOff,
                            onClick: () async {
                              if (dayOffReasonController.text.isEmpty) {
                                print("ERRor");

                                SnackBar snackBar = SnackBar(
                                  backgroundColor: theme.hintColor,
                                  content: Text(
                                    Strings.fillDayOffReason,
                                    style: theme.textTheme.titleMedium,
                                    textAlign: TextAlign.center,
                                    textDirection: TextDirection.rtl,
                                  ),
                                  duration: const Duration(seconds: 4),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                              if (model.endSelectedDate
                                  .isBefore(model.startSelectedDate)) {
                                SnackBar snackBar = SnackBar(
                                  backgroundColor: theme.hintColor,
                                  content: Text(
                                    Strings.endDateError,
                                    style: theme.textTheme.titleMedium,
                                    textAlign: TextAlign.center,
                                    textDirection: TextDirection.rtl,
                                  ),
                                  duration: const Duration(seconds: 4),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              } else {
                                var errorMsg = await model.createLeave(
                                    dayOffReasonController.text,
                                    model.selectedTypeSheet.id == 11
                                        ? model.startHour.toString()
                                        : "",
                                    model.selectedTypeSheet.id == 11
                                        ? model.endHour.toString()
                                        : "");

                                if (errorMsg.isEmpty) {
                                  SnackbarShare.showMessage(
                                      Strings.confirmDayOffSuccessfully);
                                  FocusManager.instance.primaryFocus?.unfocus();

                                  model.setStartHour(
                                    Time(
                                      hour: 00,
                                      minute: 00,
                                    ),
                                  );
                                  model.setEndHour(
                                    Time(
                                      hour: 00,
                                      minute: 00,
                                    ),
                                  );
                                  leaveReasonController.text = "";
                                  model
                                      .updateStartFormattedDate(DateTime.now());
                                  model.updateEndFormattedDate(DateTime.now());
                                  Navigator.pop(context);
                                  model.getLeaves();
                                } else {
                                  SnackBar snackBar = SnackBar(
                                    backgroundColor: theme.hintColor,
                                    content: Text(
                                      errorMsg,
                                      style: theme.textTheme.titleMedium,
                                      textAlign: TextAlign.center,
                                      textDirection: TextDirection.rtl,
                                    ),
                                    duration: const Duration(seconds: 4),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                  FocusManager.instance.primaryFocus?.unfocus();
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    )));
          });
        });
  }

  Widget balanceWidget(String title, String value) {
    return Container(
      margin: EdgeInsets.all(6),
      padding: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width * 0.25,
      height: MediaQuery.of(context).size.height * 0.155,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Divider(
            color: Colors.white,
          ),
          Text(
            value,
            style: TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
          )
        ],
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppTheme.category1,
        boxShadow: [
          BoxShadow(color: AppTheme.category1, spreadRadius: 3),
        ],
      ),
    );
  }

  Widget outLineButton(VoidCallback action, ThemeData theme, String title) {
    return OutlinedButton(
      onPressed: action,
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.only(right: 30, left: 30),
        side: BorderSide(width: 1, color: theme.primaryColorLight),
      ),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            fontFamily: "Tajawal",
            color: theme.primaryColorLight),
      ),
    );
  }

  showFilterDialog(LeaveVModel model) {
    Widget okButton = TextButton(
      child: Text(
        Strings.confirmSheet,
      ),
      onPressed: () async {
        model.getLeaves();
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
        "حدد التصنيف :",
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
      ),
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.3,
        child: Column(
          children: [
            Divider(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    model.statusLeave.length,
                    (i) {
                      return GestureDetector(
                          onTap: () {
                            model.setSelectedStatus(model.statusLeave[i]);
                          },
                          child: filterItem(
                              model.statusLeave[i].name.toString(),
                              model.selectedStatus.id ==
                                  model.statusLeave[i].id));
                    },
                  )),
            ),
          ],
        ),
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
  }

  Widget filterItem(String name, bool isSelect) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
      padding: EdgeInsets.only(right: 2, left: 2),
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width * 0.18,
      child: Text(
        name,
        style: TextStyle(
            color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppTheme.category2,
        boxShadow: [
          BoxShadow(
              color: isSelect ? AppTheme.category1 : AppTheme.category2,
              spreadRadius: 3),
        ],
      ),
    );
  }
}

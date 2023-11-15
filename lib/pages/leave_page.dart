import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:thakafah_reports/core/viewModels/leave_vmodel.dart';
import 'package:thakafah_reports/shared_widget/app_theme.dart';
import '../core/viewModels/add_model.dart';
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
  List<String> reasons = ["", "مرضية", "عرضية"];
  var selectedDate = "";
  var returnDate = "";
  TextEditingController dayOffReasonController = TextEditingController();
  TextEditingController leaveReasonController = TextEditingController();
  TextEditingController hoursController = TextEditingController();
  TextEditingController minutesController = TextEditingController();
  late TabController _tabController;
  final List<Tab> myTabs = <Tab>[
    Tab(text: "مغادرة"),
    Tab(text: "إجازة"),
  ];
  int selectedIndex = 1;

  @override
  void initState() {
    SnackbarShare.init(context);
    _tabController =
        TabController(vsync: this, length: myTabs.length, initialIndex: 1)
          ..addListener(() {
            setState(() {
              selectedIndex = _tabController.index;
            });

          });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    leaveReasonController.dispose();
    dayOffReasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return BaseView<LeaveVModel>(
        onModelReady: (model) => model.init(),
        builder: (context, model, child) {
          return mainWidget(model, theme);
        });
  }

  Widget mainWidget(LeaveVModel model, ThemeData theme) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(
              20,
            ),
            child: Text(
              "طلب إجازة / مغادرة",
              textDirection: TextDirection.rtl,
              style: theme.textTheme.titleLarge,
            ),
          ),
          Divider(
            color: Colors.grey,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.04,
            child: TabBar(
                controller: _tabController,
                labelColor: Colors.black,
                indicatorColor: theme.primaryColorLight,
                tabs: myTabs),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: TabBarView(controller: _tabController, children: [
              leaveWidget(model,theme),
              dayOffWidget(model, theme),

            ]),
          )
        ],
      ),
    );
  }

  Widget dayOffWidget(LeaveVModel model, ThemeData theme) {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.only(top: 10, right: 30, left: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
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
                                onSurface: Colors.black, // body text color
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  primary: Colors.black, // button text color
                                ),
                              ),
                            ),
                            child: child!,
                          );
                        },
                        cancelText: "إلغاء",
                        initialDate: DateTime.now(),
                        //get today's date
                        firstDate: DateTime(2000),
                        //DateTime.now() - not to allow to choose before today.
                        lastDate: DateTime(2101));

                    if (pickedDate != null) {
                      model.updateFormattedDate(pickedDate);
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.only(right: 30, left: 30),
                    side: BorderSide(width: 1, color: theme.primaryColorLight),
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
                Text(
                  "# تاريخ بدء الإجازة",
                  style: theme.textTheme.bodyLarge,
                  textDirection: TextDirection.rtl,
                ),
              ],
            )),
        Padding(
            padding: const EdgeInsets.only(right: 30, left: 30),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.33,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: DropdownButton<String>(
                        value: model.selectedTitle,
                        icon: const Icon(Icons.arrow_drop_down_rounded),
                        elevation: 16,
                        style: TextStyle(color: Colors.black38),
                        onChanged: (String? value) {
                          model.setTitle(value!);
                        },
                        items: model.titleList
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Center(
                              child: Text(
                                value,
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
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Text(
                      "# حدد نوع الإجازة",
                      style: theme.textTheme.bodyLarge,
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                ])),
        Padding(
            padding: const EdgeInsets.only(right: 30, left: 30),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.33,
                      child: Align(
                        alignment: Alignment.topRight,
                        child: DropdownButton<int>(
                          value: model.selectedDay,
                          icon: const Icon(Icons.arrow_drop_down_rounded),
                          elevation: 16,
                          alignment: Alignment.topRight,
                          style: TextStyle(color: Colors.black38),
                          onChanged: (int? value) {
                            model.setDay(value!);
                          },
                          items: model.dayList
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
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.15,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Text(
                      "# حدد عدد الأيام",
                      style: theme.textTheme.bodyLarge,
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                ])),
        Padding(
          padding: const EdgeInsets.only(top: 10, right: 30, left: 30),
          child: Align(
            alignment: Alignment.topRight,
            child: Text(
              "# سبب الإجازة",
              style: theme.textTheme.bodyLarge,
              textDirection: TextDirection.rtl,
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(top: 15, right: 30, left: 30),
          child: Column(
            children: [
              SharedEditText(
                textEditingController: dayOffReasonController,
                label: "",
                line: 3,
                icon: const Icon(
                  Icons.description,
                  size: 20,
                ),
                onChange: (){
                  model.setError(false);
                },
                onSubmit: (){
                  model.setError(false);
                },
                isObscureText: false,
              ),
             Visibility(
               visible: model.error ,
               child: Padding(
                 padding: const EdgeInsets.only(right: 10,left: 10),
                 child: Divider(color: Colors.red,thickness: 0.6,),
               ),
             )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.08, bottom: 70),
          child: SharedButton(
            buttonLabel: "تأكيد الإجازة",
            onClick: () async {
              if(dayOffReasonController.text.isEmpty){
                SnackbarShare.showMessage("يرجى تعبئة سبب الإجازة");
model.setError(true);
              }else{
                var success = await model.requestDayOff(dayOffReasonController.text);
                if (success) {
                  SnackbarShare.showMessage("تم تأكيد الإجازة بنجاح");
                  FocusManager.instance.primaryFocus?.unfocus();
                  model.setError(false);
                } else {
                  SnackbarShare.showMessage(
                      "حدث خطأ ، يرجى المحاولة مرة أخرى");
                  FocusManager.instance.primaryFocus?.unfocus();
                  model.setError(false);
                }
              }

            },
          ),
        ),
      ],
    );
  }

  Widget leaveWidget(LeaveVModel model, ThemeData theme) {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.only(top: 10, right: 30, left: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
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
                                onSurface: Colors.black, // body text color
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  primary: Colors.black, // button text color
                                ),
                              ),
                            ),
                            child: child!,
                          );
                        },
                        cancelText: "إلغاء",
                        initialDate: DateTime.now(),
                        //get today's date
                        firstDate: DateTime(2000),
                        //DateTime.now() - not to allow to choose before today.
                        lastDate: DateTime(2101));

                    if (pickedDate != null) {
                      model.updateFormattedDate(pickedDate);
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.only(right: 30, left: 30),
                    side: BorderSide(width: 1, color: theme.primaryColorLight),
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
                Text(
                  "# تاريخ المغادرة",
                  style: theme.textTheme.bodyLarge,
                  textDirection: TextDirection.rtl,
                ),
              ],
            )),

        Padding(
          padding:
          const EdgeInsets.only(right: 30, left: 30, top: 15),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.09,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width:
                      MediaQuery.of(context).size.width * 0.15,
                      child: Column(
                        children: [
                          Text("ساعة"),
                          SharedEditText(
                            textEditingController: hoursController,
                            label:  "",
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
                          Text("دقيقة"),
                          SharedEditText(
                            textEditingController:
                            minutesController,
                            label:  "",
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
                ElevatedButton(
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
                        List<String> parts =
                        resultingDuration.toString().split(":");
                        String hours = parts[0].padLeft(2, '0');
                        String minutes = parts[1];
                        hoursController.text = hours;
                        minutesController.text = minutes;
                        model.setDuration(
                            int.parse(hours), int.parse(minutes));
                      }
                      FocusManager.instance.primaryFocus?.unfocus();
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
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, right: 30, left: 30),
          child: Align(
            alignment: Alignment.topRight,
            child: Text(
              "# سبب المغادرة",
              style: theme.textTheme.bodyLarge,
              textDirection: TextDirection.rtl,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15, right: 30, left: 30),
          child: SharedEditText(
            textEditingController: leaveReasonController,
            label: "",
            line: 3,
            icon: const Icon(
              Icons.description,
              size: 20,
            ),
            isObscureText: false,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.08, bottom: 70),
          child: SharedButton(
            buttonLabel: "تأكيد المغادرة",
            onClick: () async {
              if(leaveReasonController.text.isEmpty|| (hoursController.text.isEmpty||minutesController.text.isEmpty)){
                SnackbarShare.showMessage("يرجى تعبئة كامل الحقول");

              }else{
                var success = await model.requestLeave(leaveReasonController.text);
                if (success) {
                  SnackbarShare.showMessage("تم تأكيد المغادرة بنجاح");
                } else {
                  SnackbarShare.showMessage(
                      "حدث خطأ ، يرجى المحاولة مرة أخرى");
                }
              }

            },
          ),
        ),
      ],
    );
  }
}

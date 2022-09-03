import 'package:daily_todo/models/task.dart';
import 'package:daily_todo/ui/add_task_page.dart';
import 'package:daily_todo/ui/theme.dart';
import 'package:daily_todo/ui/widgets/button.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../controlers/task_controler.dart';
import '../services/notification_service.dart';
import '../services/theme_services.dart';
import 'widgets/task_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var notifyHelper;
  DateTime _selectedDateTime = DateTime.now();
  final TaskController _taskController = Get.put(TaskController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(),
        body: Column(
          children: [
            _addTaskBar(),
            _addDateBar(),
            _showTask(),
          ],
        ));
  }

  _showTask() {
    return Expanded(child: Obx(() {
      return ListView.builder(
          itemCount: _taskController.taskList.length,
          itemBuilder: (_, index) {
            print(_taskController.taskList.length);
            return AnimationConfiguration.staggeredList(
                position: index,
                child: SlideAnimation(
                  child: FadeInAnimation(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _showBottomSheet(
                                _taskController.taskList[index], context);
                            _taskController.getTasks();
                          },
                          child:
                              TaskTile(task: _taskController.taskList[index]),
                        )
                      ],
                    ),
                  ),
                ));
          });
    }));
  }

  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 15, left: 15),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80.0,
        initialSelectedDate: DateTime.now(),
        selectedTextColor: Colors.white,
        selectionColor: blueish,
        dateTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
                fontSize: 18, color: Colors.grey, fontWeight: FontWeight.w600)),
        dayTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
                fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w600)),
        monthTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
                fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w600)),
        onDateChange: (date) {
          _selectedDateTime = date;
        },
      ),
    );
  }

  _addTaskBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMd().format(DateTime.now()),
                style: subHeadingStyle,
              ),
              Text("Today", style: headingStyle),
            ],
          ),
          MyButton(
              label: "+ Add Task",
              onTap: () {
                Get.to(const AddTaskPage());
              })
        ],
      ),
    );
  }

  _appBar() {
    return AppBar(
      elevation: 0.0,
      backgroundColor: context.theme.primaryColor,
      title: Text(
        "Daily Todo",
        style: TextStyle(color: Get.isDarkMode ? Colors.white : Colors.black87),
      ),
      leading: GestureDetector(
        onTap: () {
          ThemeServices().switchTheme();
          notifyHelper.displayNotification(
              title: "Theme Changed",
              body: Get.isDarkMode
                  ? "Light Mode Activated"
                  : "Dark Mode Activated");

          notifyHelper.scheduledNotification();
        },
        child: Icon(
          Get.isDarkMode ? Icons.wb_sunny_rounded : Icons.nightlight_round,
          size: 24.0,
          color: Get.isDarkMode ? Colors.white : Colors.black87,
        ),
      ),
      actions: const [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage(
              "https://www.w3schools.com/w3images/avatar2.png",
            ),
          ),
        )
      ],
    );
  }

  _showBottomSheet(Task task, BuildContext context) {
    Size size = MediaQuery.of(context).size;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 4),
        height: task.isCompleted == 1 ? size.height * 0.25 : size.height * 0.35,
        color: Get.isDarkMode ? darkHeader : white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
              ),
            ),
            const SizedBox(),
            task.isCompleted == 1
                ? Container()
                : _bottomSheetButton(
                    context: context,
                    label: "Task Completed",
                    onPres: () {
                      _taskController.updateTask(task);
                      _taskController.getTasks();
                      Get.back();
                    },
                    buttonColor: Colors.blueAccent),
            _bottomSheetButton(
                context: context,
                label: "Task Delete",
                onPres: () {
                  _taskController.deleteTask(task);
                  _taskController.getTasks();

                  Get.back();
                },
                buttonColor: Colors.redAccent),
            const SizedBox(),
            _bottomSheetButton(
                context: context,
                label: "Close",
                onPres: () {
                  Get.back();
                },
                isClose: true)
          ],
        ),
      ),
    );
  }

  _bottomSheetButton(
      {required String label,
      required Function() onPres,
      Color buttonColor = Colors.black,
      bool isClose = false,
      required BuildContext context}) {
    return GestureDetector(
      onTap: onPres,
      child: Container(
        margin: const EdgeInsets.only(top: 5),
        height: 55,
        width: MediaQuery.of(context).size.width * .9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: isClose
                ? Get.isDarkMode
                    ? Colors.grey[600]!
                    : Colors.grey[300]!
                : Colors.transparent,
          ),
          color: isClose ? Colors.transparent : buttonColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
            child: Text(
          label,
          style:GoogleFonts.lato(
            textStyle: titleStyle.copyWith(color: isClose ? Colors.grey : Colors.white, fontWeight: FontWeight.bold)

          )
              ,
        )),
      ),
    );
  }
}

import 'package:daily_todo/controlers/task_controler.dart';
import 'package:daily_todo/models/task.dart';
import 'package:daily_todo/ui/theme.dart';
import 'package:daily_todo/ui/widgets/button.dart';
import 'package:daily_todo/ui/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  DateTime _selectedDate = DateTime.now();
  String _endTime = "9:30";
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()..toString());

  int _selectedRemind = 5;

  List<int> remindList = [5, 10, 15, 20, 30, 60];

  String _selectedRepeat = "None";
  List<String> repeatList = ["None", "Daily", "Weekly", "Monthly"];
  int _selectedColor = 0;

  final TextEditingController _titleControler = TextEditingController();
  final TextEditingController _noteControler = TextEditingController();

  final TaskController _taskController = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: context.theme.backgroundColor,
        appBar: _appBar(context),
        body: Container(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
          child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(
                  "Add Task",
                  style: subHeadingStyle,
                ),
                MyInputField(
                  title: "Title",
                  hint: "Enter Title Here...",
                  controller: _titleControler,
                ),
                MyInputField(
                  title: "Note",
                  hint: "Enter Note Here...",
                  controller: _noteControler,
                ),
                MyInputField(
                  title: "Date",
                  hint: DateFormat.yMd().format(_selectedDate),
                  widget: IconButton(
                    onPressed: () {
                      print("Icon Cliked");
                      _getDateFromUser();
                    },
                    icon: const Icon(
                      Icons.date_range_rounded,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: MyInputField(
                        title: "Start Time",
                        hint: _startTime,
                        widget: IconButton(
                          onPressed: () {
                            _getTimeFromUser(isFirstTime: true);
                          },
                          icon: const Icon(
                            Icons.access_time_rounded,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 4.0,
                    ),
                    Expanded(
                      child: MyInputField(
                        title: "End Time",
                        hint: _endTime,
                        widget: IconButton(
                          onPressed: () {
                            _getTimeFromUser(isFirstTime: false);
                          },
                          icon: const Icon(
                            Icons.timer_outlined,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                MyInputField(
                  title: "Remind",
                  hint: "$_selectedRemind minutes early",
                  widget: DropdownButton(
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                    iconSize: 32,
                    elevation: 4,
                    style: subTitleStyle,
                    underline: Container(
                      height: 0,
                    ),
                    items:
                        remindList.map<DropdownMenuItem<String>>((int value) {
                      return DropdownMenuItem<String>(
                        value: value.toString(),
                        child: Text(value.toString(),style: TextStyle(color: Get.isDarkMode?Colors.white : Colors.black ),),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        _selectedRemind = int.parse(value!);
                      });
                    },
                  ),
                ),
                MyInputField(
                  title: "Repeat",
                  hint: _selectedRepeat,
                  widget: DropdownButton(
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                    iconSize: 32,
                    elevation: 4,
                    style: subTitleStyle,
                    underline: Container(
                      height: 0,
                    ),
                    items: repeatList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: TextStyle(color: Get.isDarkMode?Colors.white : Colors.black ),),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        _selectedRepeat = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _colorPallete(),
                    MyButton(
                        label: "Create Task",
                        onTap: () {
                          _validate();
                        })
                  ],
                )
              ])),
        ));
  }

  _validate() {
    if (_titleControler.text.isNotEmpty && _noteControler.text.isNotEmpty) {
      // Add data to Database

      _addDataToDB();

      _taskController.getTasks();

      Get.back();
    } else if (_titleControler.text.isEmpty || _noteControler.text.isEmpty) {
      Get.snackbar("Required", "All Feild Are Required",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.brown,
          icon: const Icon(
            Icons.warning_rounded,
            color: Colors.pinkAccent,
          ));
    }
  }

  _colorPallete() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Color",
          style: titleStyle,
        ),
        const SizedBox(
          height: 4,
        ),
        Row(
          children: List<Widget>.generate(3, (index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: index == 0
                      ? Colors.brown
                      : index == 1
                          ? Colors.pinkAccent
                          : Colors.amberAccent,
                  child: _selectedColor == index
                      ? const Icon(
                          Icons.done,
                          color: Colors.white,
                        )
                      : Container(),
                ),
              ),
            );
          }),
        )
      ],
    );
  }

  _getTimeFromUser({required bool isFirstTime}) async {
    var pickedTime = await _showTimePicker();

    String _formatedTime = pickedTime.format(context);

    if (pickedTime == null) {
      print("Something gone wong");
    } else if (isFirstTime == true) {
      setState(() {
        _startTime = _formatedTime;
      });
    } else if (isFirstTime == false) {
      setState(() {
        _endTime = _formatedTime;
      });
    }
  }

  _showTimePicker() {
    return showTimePicker(
        context: context,
        initialEntryMode: TimePickerEntryMode.input,
        initialTime: TimeOfDay.now());
  }

  _getDateFromUser() async {
    DateTime? _pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2100));

    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
      });
    } else {}
  }

  _appBar(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      backgroundColor: context.theme.primaryColor,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Icon(
          Icons.arrow_back_ios,
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

  _addDataToDB() async {
    var task = Task(
        title: _titleControler.text,
        note: _noteControler.text,
        isCompleted: 0,
        date: DateFormat.yMd().format(_selectedDate),
        startTime: _startTime,
        endTime: _endTime,
        color: _selectedColor,
        remind: _selectedRemind,
        repeat: _selectedRepeat);

   int row= await _taskController.addTask(task: task);
   print("Row Number :  $row");


  }
}

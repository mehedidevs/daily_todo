import 'package:daily_todo/db/db_helper.dart';
import 'package:daily_todo/models/task.dart';
import 'package:get/get.dart';

class TaskController extends GetxController {
  @override
  void onReady() {
    // TODO: implement onReady
    getTasks();
    super.onReady();
  }

  var taskList = <Task>[].obs;

  void getTasks() async {
    List<Map<String, dynamic>> tasks = await DbHelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
  }

  Future<int> addTask({Task? task}) async {
    return await DbHelper.insert(task);
  }

  Future<int> deleteTask(Task task) async {

    return  await DbHelper.delete(task);
  }
  Future<int> updateTask(Task task) async {

    return  await DbHelper.update(task);
  }


}

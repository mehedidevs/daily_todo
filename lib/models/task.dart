class Task {
  int? id;
  String? title;
  String note;
  int isCompleted;
  String date;
  String startTime;
  String endTime;
  int color;
  int remind;
  String repeat;

  Task(
      { this.id,
      required this.title,
      required this.note,
      required this.isCompleted,
      required this.date,
      required this.startTime,
      required this.endTime,
      required this.color,
      required this.remind,
      required this.repeat});

 factory Task.fromJson(Map<String , dynamic> json){
    var task= Task(id:json['id'] , title: json['title'], note: json['note'] , isCompleted:json ['isCompleted'],
        date: json['date'] , startTime: json['startTime'], endTime: json['endTime'], color: json['color'], remind:json ['remind'], repeat: json['repeat']);

    return task;

  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{
      'id': id,
      'title': title,
      'note': note,
      'isCompleted': isCompleted,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'color': color,
      'remind': remind,
      'repeat': repeat
    };

    return data;
  }
}

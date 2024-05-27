class TaskModel {
  final String id;
  final String title;
  final String description;
  final String estimatedTime;

  final DateTime dueDateTime;
  final bool taskStatus;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.estimatedTime,
    required this.dueDateTime,
    required this.taskStatus,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'estimatedTime': estimatedTime,
        'dueDateTime': dueDateTime.toIso8601String(),
        'taskStatus': taskStatus,
      };

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        estimatedTime: json['estimatedTime'],
        dueDateTime: DateTime.parse(json['dueDateTime']),
        taskStatus: json['taskStatus'],
      );
}

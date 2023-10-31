class TaskValue {
  String? key, task,email;
  int status;
  TaskValue({
    required this.key,
    required this.task,
    required this.status,
    required this.email,
    
  });
  factory TaskValue.formJson(Map<String, dynamic> json) {
    return TaskValue(
      key: json['key'],
      task: json['task'],
      status: json['taskStatus'],
      email : json['email']
    );
  }
}

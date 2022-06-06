class chat_modal {
  String? sendBy;
  String? message;
  int? time;

  chat_modal({this.sendBy, this.message,this.time});

  factory chat_modal.fromJson(Map<String, dynamic> jsonData) {
    return chat_modal(
      sendBy: jsonData['sendBy'],
      message: jsonData['message'],
      time: jsonData['time'],
    );
  }
}

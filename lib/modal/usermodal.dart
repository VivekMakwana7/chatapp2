class user_modal {
  String? userName;
  String? userEmail;

  user_modal({this.userName, this.userEmail});

  factory user_modal.fromJson(Map<String, dynamic> jsonData) {
    return user_modal(
      userName: jsonData['userName'],
      userEmail: jsonData['userEmail'],
    );
  }
}

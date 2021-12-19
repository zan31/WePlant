class User {
  final int uId;
  final String uName;
  final String uEmail;
  final String uPass;

  User({
    required this.uId,
    required this.uName,
    required this.uEmail,
    required this.uPass
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uId: json['uId'],
      uName: json['uName'],
      uEmail: json['uEmail'],
      uPass: json['uPass'],
    );
  }
}

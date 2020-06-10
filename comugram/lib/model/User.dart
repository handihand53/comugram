class User {
  String uid;
  String username;
  String email;
  String pass;

  User({this.uid, this.username, this.email, this.pass});

  User.fromMap(Map<String, dynamic> historyMaps) {
    this.uid = historyMaps['id'];
    this.username = historyMaps['username'];
    this.email = historyMaps['email'];
    this.pass = historyMaps['pass'];
  }
  Map<String, dynamic> toMap() {
    return {
      'id': uid,
      'username': username,
      'email': email,
      'pass': pass,
    };
  }
}
class User {
  String uid;
  String username;
  String email;

  User({this.uid, this.username, this.email});

  User.fromMap(Map<String, dynamic> userMaps) {
    this.uid = userMaps['id'];
    this.username = userMaps['username'];
    this.email = userMaps['email'];
  }
  Map<String, dynamic> toMap() {
    return {
      'id': uid,
      'username': username,
      'email': email,
    };
  }
}
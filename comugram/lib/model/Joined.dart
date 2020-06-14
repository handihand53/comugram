class Joined {
  String uid;
  String idKom;

  Joined({this.uid, this.idKom,});

  Joined.fromMap(Map<String, dynamic> joinedMaps) {
    this.uid = joinedMaps['id'];
    this.idKom = joinedMaps['idKom'];
  }
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'idKom': idKom,
    };
  }
}
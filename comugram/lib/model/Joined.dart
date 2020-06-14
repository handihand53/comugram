class Joined {
  String uid;
  String kom_id;

  Joined({this.uid, this.kom_id});

  Joined.fromMap(Map<String, dynamic> komunitasMaps) {
    this.uid = komunitasMaps['id_user'];
    this.kom_id = komunitasMaps['id_komunitas'];
  }
  Map<String, dynamic> toMap() {
    return {
      'id_user': uid,
      'id_komunitas': kom_id,
    };
  }
}
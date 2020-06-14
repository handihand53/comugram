class Post {
  String id_post;
  String id_user;
  String id_komunitas;
  String location;
  String imageUrl;
  String caption;
  String tanggalBuat;

  Post(
      {this.id_post,
      this.id_user,
      this.id_komunitas,
      this.location,
      this.imageUrl,
      this.caption,
      this.tanggalBuat});
  Map<String, dynamic> toMap() {
    return {
      "id_user": this.id_user,
      "id_post": this.id_post,
      "id_komunitas": this.id_komunitas,
      "location": this.location,
      "imageUrl": this.imageUrl,
      "caption": this.caption,
      "tanggalBuat": this.tanggalBuat
    };
  }
}

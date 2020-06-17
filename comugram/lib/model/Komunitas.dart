class Komunitas {
  String uid;
  String kategori;
  String imageUrl;
  String namaKomunitas;
  String deskripsi;
  String owner;
  String namaOwner;
  String tanggalBuat;
  String joinedId;
  Komunitas(
      {this.uid,
      this.kategori,
      this.imageUrl,
      this.namaKomunitas,
      this.deskripsi,
      this.owner,
      this.tanggalBuat});

  Komunitas.fromMap(Map<String, dynamic> komunitasMaps) {
    this.uid = komunitasMaps['id'];
    this.kategori = komunitasMaps['kategori'];
    this.imageUrl = komunitasMaps['imageUrl'];
    this.namaKomunitas = komunitasMaps['namaKomunitas'];
    this.deskripsi = komunitasMaps['deskripsi'];
    this.owner = komunitasMaps['owner'];
    this.namaOwner = komunitasMaps['namaOwner'];
    this.tanggalBuat = komunitasMaps['tanggalBuat'];
    this.joinedId = komunitasMaps['joinedId'];
  }
  Map<String, dynamic> toMap() {
    return {
      'id': uid,
      'kategori': kategori,
      'imageUrl': imageUrl,
      'namaKomunitas': namaKomunitas,
      'deskripsi': deskripsi,
      'owner': owner,
      'tanggalBuat': tanggalBuat,
      'searchKomunitas': namaKomunitas.toUpperCase(),
    };
  }
}

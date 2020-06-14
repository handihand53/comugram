
class Validation {
  String validateEmail(String value) {
    Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Coba tulis Email dengan benar sebagai Verifikasi';
    else
      return null;
  }

  String validateName(String value) {
    if (value.isEmpty || value.length <= 3 || value.length >= 20) { //JIKA VALUE KOSONG
      return 'Biarkan orang lain mengenali Anda secara singkat'; //MAKA PESAN DITAMPILKAN
    }
    return null;
  }

  String validatePass(String value) {
    if (value.length < 8) { //JIKA VALUE KOSONG
      return 'Password harus lebih dari 8 karakter'; //MAKA PESAN DITAMPILKAN
    }
    return null;
  }

  String validateNameKomunitas(String value) {
    if (value.isEmpty || value.length <= 3 || value.length >= 20) { //JIKA VALUE KOSONG
      return 'Biarkan orang lain tahu nama Komunitas Anda'; //MAKA PESAN DITAMPILKAN
    }
    return null;
  }
  String validateDesk(String value) {
    if (value.isEmpty || value.length <= 3 || value.length > 3000) { //JIKA VALUE KOSONG
      return 'Biarkan orang lain tahu Komunitas anda secara ringkas'; //MAKA PESAN DITAMPILKAN
    }
    return null;
  }
}
class PegawaiModel {
  String responsecode = "";
  String responsemsg = "";
  List<Pegawai> pegawai = [];

  PegawaiModel({required this.responsecode, required this.responsemsg, required this.pegawai});

  PegawaiModel.fromJson(Map<String, dynamic> json) {
    responsecode = json['responsecode'];
    responsemsg = json['responsemsg'];
    if (json['pegawai'] != null) {
      json['pegawai'].forEach((v) {
        pegawai.add(new Pegawai.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['responsecode'] = this.responsecode;
    data['responsemsg'] = this.responsemsg;
    if (this.pegawai != null) {
      data['pegawai'] = this.pegawai.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pegawai {
  int id = 0;
  String kategoriPegawai = "";
  String nama = "";
  String hp = "";
  String email = "";
  String password = "";

  Pegawai(
      {required this.id,
      required this.kategoriPegawai,
      required this.nama,
      required this.hp,
      required this.email,
      required this.password});

  Pegawai.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    kategoriPegawai = json['kategori_pegawai'];
    nama = json['nama'];
    hp = json['hp'];
    email = json['email'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['kategori_pegawai'] = this.kategoriPegawai;
    data['nama'] = this.nama;
    data['hp'] = this.hp;
    data['email'] = this.email;
    data['password'] = this.password;
    return data;
  }
}

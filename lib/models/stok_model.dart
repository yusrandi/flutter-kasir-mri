class StokModel {
  String responsecode = "";
  String responsemsg = "";
  List<Stok> stok = [];

  StokModel({required this.responsecode, required this.responsemsg, required this.stok});

  StokModel.fromJson(Map<String, dynamic> json) {
    responsecode = json['responsecode'];
    responsemsg = json['responsemsg'];
    if (json['stok'] != null) {
      json['stok'].forEach((v) {
        stok.add(new Stok.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['responsecode'] = this.responsecode;
    data['responsemsg'] = this.responsemsg;
    if (this.stok != null) {
      data['stok'] = this.stok.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Stok {
  int id = 0;
  String satuan = "";
  String nama = "";
  String jumlah = "";
  String harga = "";
  String kontak = "";
  String alamat = "";

  Stok(
      {required this.id,
      required this.satuan,
      required this.nama,
      required this.jumlah,
      required this.harga,
      required this.kontak,
      required this.alamat});

  Stok.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    satuan = json['satuan'];
    nama = json['nama'];
    jumlah = json['jumlah'];
    harga = json['harga'];
    kontak = json['kontak'];
    alamat = json['alamat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['satuan'] = this.satuan;
    data['nama'] = this.nama;
    data['jumlah'] = this.jumlah;
    data['harga'] = this.harga;
    data['kontak'] = this.kontak;
    data['alamat'] = this.alamat;
    return data;
  }
}

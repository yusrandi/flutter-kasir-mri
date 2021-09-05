class PengeluaranModel {
  String responsecode = "";
  String responsemsg = "";
  List<Pengeluaran> pengeluaran = [];

  PengeluaranModel({required this.responsecode, required this.responsemsg, required this.pengeluaran});

  PengeluaranModel.fromJson(Map<String, dynamic> json) {
    responsecode = json['responsecode'];
    responsemsg = json['responsemsg'];
    if (json['pengeluaran'] != null) {
      json['pengeluaran'].forEach((v) {
        pengeluaran.add(new Pengeluaran.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['responsecode'] = this.responsecode;
    data['responsemsg'] = this.responsemsg;
    if (this.pengeluaran != null) {
      data['pengeluaran'] = this.pengeluaran.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pengeluaran {
  int id = 0;
  String kategori = "";
  String sumber = "";
  String jumlah = "";
  String catatan = "";

  Pengeluaran(
      {required this.id,
      required this.kategori,
      required this.sumber,
      required this.jumlah,
      required this.catatan});

  Pengeluaran.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    kategori = json['kategori'];
    sumber = json['sumber'];
    jumlah = json['jumlah'];
    catatan = json['catatan'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['kategori'] = this.kategori;
    data['sumber'] = this.sumber;
    data['jumlah'] = this.jumlah;
    data['catatan'] = this.catatan;
    return data;
  }
}

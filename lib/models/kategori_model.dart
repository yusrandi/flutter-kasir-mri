class KategoriModel {
  String responsecode = "";
  String responsemsg = "";
  List<Kategori> kategori = [];

  KategoriModel({required this.responsecode, required this.responsemsg, required this.kategori});

  KategoriModel.fromJson(Map<String, dynamic> json) {
    responsecode = json['responsecode'];
    responsemsg = json['responsemsg'];
    if (json['kategori'] != null) {
      json['kategori'].forEach((v) {
        kategori.add(new Kategori.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['responsecode'] = this.responsecode;
    data['responsemsg'] = this.responsemsg;
    if (this.kategori != null) {
      data['kategori'] = this.kategori.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Kategori {
  int id = 0;
  String name = "";

  Kategori({required this.id, required this.name});

  Kategori.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

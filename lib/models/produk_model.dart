class ProdukModel {
  String responsecode = "";
  String responsemsg = "";
  List<Produk> produk = [];

  ProdukModel({required this.responsecode, required this.responsemsg, required this.produk});

  ProdukModel.fromJson(Map<String, dynamic> json) {
    responsecode = json['responsecode'];
    responsemsg = json['responsemsg'];
    if (json['produk'] != null) {
      
      json['produk'].forEach((v) {
        produk.add(new Produk.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['responsecode'] = this.responsecode;
    data['responsemsg'] = this.responsemsg;
    if (this.produk != null) {
      data['produk'] = this.produk.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Produk {
  int id = 0;
  int kategoriId = 0;
  String foto = "";
  String nama = "";
  String harga = "";
  String modal = "";

  Produk(
      {required this.id,
      required this.kategoriId,
      required this.foto,
      required this.nama,
      required this.harga,
      required this.modal
      });

  Produk.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    kategoriId = json['kategori_id'];
    foto = json['foto'];
    nama = json['nama'];
    harga = json['harga'];
    modal = json['modal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['kategori_id'] = this.kategoriId;
    data['foto'] = this.foto;
    data['nama'] = this.nama;
    data['harga'] = this.harga;
    data['modal'] = this.modal;
    return data;
  }
}

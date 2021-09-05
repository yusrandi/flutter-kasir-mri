class TransaksiModel {
  String responsecode = "";
  String responsemsg = "";
  int pengeluaran = 0;
  List<Transaksi> transaksi = [];

  TransaksiModel({required this.responsecode, required this.responsemsg, required this.pengeluaran, required this.transaksi});

  TransaksiModel.fromJson(Map<String, dynamic> json) {
    responsecode = json['responsecode'];
    responsemsg = json['responsemsg'];
    pengeluaran = json['pengeluaran'];
    if (json['transaksi'] != null) {
      json['transaksi'].forEach((v) {
        transaksi.add(new Transaksi.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['responsecode'] = this.responsecode;
    data['responsemsg'] = this.responsemsg;
    if (this.transaksi != null) {
      data['transaksi'] = this.transaksi.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Transaksi {
  int id = 0;
  String kodeTransaksi = "";
  String tanggal = "";
  int total = 0;
  List<DetailTransaksis> detailTransaksis = [];

  Transaksi(
      {required this.id,
      required this.kodeTransaksi,
      required this.tanggal,
      required this.total,
      required this.detailTransaksis});

  Transaksi.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    kodeTransaksi = json['kode_transaksi'];
    tanggal = json['tanggal'];
    total = json['total'];
    if (json['detail_transaksis'] != null) {
      json['detail_transaksis'].forEach((v) {
        detailTransaksis.add(new DetailTransaksis.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['kode_transaksi'] = this.kodeTransaksi;
    data['tanggal'] = this.tanggal;
    data['total'] = this.total;
    if (this.detailTransaksis != null) {
      data['detail_transaksis'] =
          this.detailTransaksis.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DetailTransaksis {
  int id = 0;
  int transaksiId = 0;
  int produkId = 0;
  int qty = 0;
  
  DetailTransaksis(
      {required this.id,
      required this.transaksiId,
      required this.produkId,
      required this.qty});

  DetailTransaksis.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    transaksiId = json['transaksi_id'];
    produkId = json['produk_id'];
    qty = json['qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['transaksi_id'] = this.transaksiId;
    data['produk_id'] = this.produkId;
    data['qty'] = this.qty;
    return data;
  }
}


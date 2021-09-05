import 'package:kasir_mri/models/pegawai_model.dart';

class AbsensiModel {
  String responsecode = "";
  String responsemsg = "";
  List<Absensi> absensi = [];

  AbsensiModel({required this.responsecode, required this.responsemsg, required this.absensi});

  AbsensiModel.fromJson(Map<String, dynamic> json) {
    responsecode = json['responsecode'];
    responsemsg = json['responsemsg'];
    if (json['absensi'] != null) {
      json['absensi'].forEach((v) {
        absensi.add(new Absensi.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['responsecode'] = this.responsecode;
    data['responsemsg'] = this.responsemsg;
    if (this.absensi != null) {
      data['absensi'] = this.absensi.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Absensi {
  int id = 0;
  String foto = "";
  String tanggal = "";
  String status = "";
  int pegawaiId = 0;
  Pegawai? pegawai;

  Absensi(
      {required this.id,
        required this.foto,
        required this.tanggal,
        required this.status,
        required this.pegawaiId,
        this.pegawai});

  Absensi.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    foto = json['foto'];
    tanggal = json['tanggal'];
    status = json['status'];
    pegawaiId = json['pegawai_id'];
    pegawai =
    json['pegawai'] != null ? new Pegawai.fromJson(json['pegawai']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['foto'] = this.foto;
    data['tanggal'] = this.tanggal;
    data['status'] = this.status;
    data['pegawai_id'] = this.pegawaiId;
    if (this.pegawai != null) {
      data['pegawai'] = this.pegawai!.toJson();
    }
    return data;
  }
}


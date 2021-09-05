import 'package:kasir_mri/models/pegawai_model.dart';

class AuthModel {
  String responsecode = "";
  String responsemsg = "";
  Pegawai? pegawai;

  AuthModel({required this.responsecode, required this.responsemsg, this.pegawai});

  AuthModel.fromJson(Map<String, dynamic> json) {
    responsecode = json['responsecode'];
    responsemsg = json['responsemsg'];
    pegawai =
        json['pegawai'] != null ? new Pegawai.fromJson(json['pegawai']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['responsecode'] = this.responsecode;
    data['responsemsg'] = this.responsemsg;
    if (this.pegawai != null) {
      data['pegawai'] = this.pegawai!.toJson();
    }
    return data;
  }
}


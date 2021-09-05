import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kasir_mri/config/api.dart';
import 'package:kasir_mri/models/pegawai_model.dart';
import 'package:kasir_mri/models/response_model.dart';

abstract class PegawaiRepository {
  Future<PegawaiModel> fetchPegawais();
  Future<ResponseModel> PegawaiStore(Pegawai pegawai);
  Future<ResponseModel> PegawaiUpdate(String id, Pegawai pegawai);
  Future<ResponseModel> PegawaiDelete(String id);

}
class PegawaiRepositoryImpl implements PegawaiRepository {
  static const TAG = "PegawaiRepositoryImpl";

  @override
  Future<PegawaiModel> fetchPegawais() async{
    var _response = await http.get(Uri.parse(Api.instance.pegawaiURL));
    print("$TAG, fetchPegawais ${_response.statusCode}");
    if (_response.statusCode == 201) {
      print("$TAG fetchPegawais true ");
      var data = json.decode(_response.body);
      print("Data $data");
      PegawaiModel model = PegawaiModel.fromJson(data);
      return model;
    } else {
      print("$TAG getLogin else");
      throw Exception();
    }
  }

  @override
  Future<ResponseModel> PegawaiStore(Pegawai pegawai)async {
    var _response = await http.post(Uri.parse(Api.instance.pegawaiURL), body: {
      "kategori": pegawai.kategoriPegawai,
      "nama" : pegawai.nama,
      "hp" : pegawai.hp,
      "email" : pegawai.email,
      "password" : pegawai.password,
      });
    print("$TAG, PegawaiStore ${_response.statusCode}");
    if (_response.statusCode == 201) {
      var data = json.decode(_response.body);
      print("Data $data");
      ResponseModel model = ResponseModel.fromJson(data);
      return model;
    } else {
      throw Exception();
    }
  }

  @override
  Future<ResponseModel> PegawaiUpdate(String id, Pegawai pegawai) async{
    var url = Api.instance.pegawaiURL+"/"+id;

    var _response = await http.put(Uri.parse(url), body: {
      "kategori": pegawai.kategoriPegawai,
      "nama" : pegawai.nama,
      "hp" : pegawai.hp,
      "email" : pegawai.email,
      "password" : pegawai.password,
      });
    print("$TAG, PegawaiUpdate ${_response.statusCode}");
    if (_response.statusCode == 201) {
      var data = json.decode(_response.body);
      print("Data $data");
      ResponseModel model = ResponseModel.fromJson(data);
      return model;
    } else {
      throw Exception();
    }
  }

  @override
  Future<ResponseModel> PegawaiDelete(String id) async {
    print("PegawaiDelete $id");
    var _response = await http.delete(Uri.parse(Api.instance.pegawaiURL+"/"+id));
    print("$TAG, PegawaiDelete ${_response.statusCode}");
    if (_response.statusCode == 201) {
      var data = json.decode(_response.body);
      print("Data $data");
      ResponseModel model = ResponseModel.fromJson(data);
      return model;
    } else {
      throw Exception();
    }
  }
}

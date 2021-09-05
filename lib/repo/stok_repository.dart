import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kasir_mri/config/api.dart';
import 'package:kasir_mri/models/response_model.dart';
import 'package:kasir_mri/models/stok_model.dart';

abstract class StokRepository {
  Future<StokModel> fetchStoks();
  Future<ResponseModel> StokStore(Stok stok);
  Future<ResponseModel> StokUpdate(String id, Stok stok);
  Future<ResponseModel> StokDelete(String id);

}
class StokRepositoryImpl implements StokRepository {
  static const TAG = "StokRepositoryImpl";

  @override
  Future<StokModel> fetchStoks() async{
    var _response = await http.get(Uri.parse(Api.instance.stokURL));
    print("$TAG, fetchStoks ${_response.statusCode}");
    if (_response.statusCode == 201) {
      print("$TAG fetchStoks true ");
      var data = json.decode(_response.body);
      print("Data $data");
      StokModel model = StokModel.fromJson(data);
      return model;
    } else {
      print("$TAG getLogin else");
      throw Exception();
    }
  }

  @override
  Future<ResponseModel> StokStore(Stok stok)async {
    var _response = await http.post(Uri.parse(Api.instance.stokURL), body: {
      "satuan": stok.satuan,
      "nama": stok.nama,
      "jumlah": stok.jumlah,
      "harga": stok.harga,
      "kontak": stok.kontak,
      "alamat": stok.alamat,
      });
    print("$TAG, StokStore ${_response.statusCode}");
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
  Future<ResponseModel> StokUpdate(String id, Stok stok) async{
    var url = Api.instance.stokURL+"/"+id;

    var _response = await http.put(Uri.parse(url), body: {
      "satuan": stok.satuan,
      "nama": stok.nama,
      "jumlah": stok.jumlah,
      "harga": stok.harga,
      "kontak": stok.kontak,
      "alamat": stok.alamat,
      });
    print("$TAG, StokUpdate ${_response.statusCode}");
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
  Future<ResponseModel> StokDelete(String id) async {
    print("StokDelete $id");
    var _response = await http.delete(Uri.parse(Api.instance.stokURL+"/"+id));
    print("$TAG, StokDelete ${_response.statusCode}");
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

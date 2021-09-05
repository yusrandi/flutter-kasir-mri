import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kasir_mri/config/api.dart';
import 'package:kasir_mri/models/kategori_model.dart';
import 'package:kasir_mri/models/response_model.dart';

abstract class KategoriRepository {
  Future<KategoriModel> fetchKategoris();
  Future<ResponseModel> kategoriStore(String name);
  Future<ResponseModel> kategoriUpdate(int id, String name);
  Future<ResponseModel> kategoriDelete(int id, String name);

}
class KategoriRepositoryImpl implements KategoriRepository {
  static const TAG = "KategoriRepositoryImpl";

  @override
  Future<KategoriModel> fetchKategoris() async{
    var _response = await http.get(Uri.parse(Api.instance.kategoriURL));
    print("$TAG, fetchKategoris ${_response.statusCode}");
    if (_response.statusCode == 201) {
      print("$TAG fetchKategoris true ");
      var data = json.decode(_response.body);
      print("Data $data");
      KategoriModel model = KategoriModel.fromJson(data);
      return model;
    } else {
      print("$TAG getLogin else");
      throw Exception();
    }
  }

  @override
  Future<ResponseModel> kategoriStore(String name)async {
    var _response = await http.post(Uri.parse(Api.instance.kategoriURL), body: {"name": name});
    print("$TAG, kategoriStore ${_response.statusCode}");
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
  Future<ResponseModel> kategoriUpdate(int id, String name) async{
    var url = Api.instance.kategoriURL+"/"+id.toString();

    var _response = await http.put(Uri.parse(url), body: {"name": name});
    print("$TAG, kategoriUpdate ${_response.statusCode}");
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
  Future<ResponseModel> kategoriDelete(int id, String name) async {
    print("kategoriDelete $id");
    var _response = await http.delete(Uri.parse(Api.instance.kategoriURL+"/"+id.toString()), body: {"name": name});
    print("$TAG, kategoriDelete ${_response.statusCode}");
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

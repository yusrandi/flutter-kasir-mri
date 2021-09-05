import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kasir_mri/config/api.dart';
import 'package:kasir_mri/models/pengeluaran_modal.dart';
import 'package:kasir_mri/models/response_model.dart';

abstract class PengeluaranRepository {
  Future<PengeluaranModel> fetchPengeluarans();
  Future<ResponseModel> PengeluaranStore(Pengeluaran pengeluaran);
  Future<ResponseModel> PengeluaranUpdate(String id, Pengeluaran pengeluaran);
  Future<ResponseModel> PengeluaranDelete(String id);
}
class PengeluaranRepositoryImpl implements PengeluaranRepository {
  static const TAG = "PengeluaranRepositoryImpl";

  @override
  Future<PengeluaranModel> fetchPengeluarans() async{
    var _response = await http.get(Uri.parse(Api.instance.pengeluaranURL));
    print("$TAG, fetchPengeluarans ${_response.statusCode}");
    if (_response.statusCode == 201) {
      print("$TAG fetchPengeluarans true ");
      var data = json.decode(_response.body);
      print("Data $data");
      PengeluaranModel model = PengeluaranModel.fromJson(data);
      return model;
    } else {
      print("$TAG getLogin else");
      throw Exception();
    }
  }

  @override
  Future<ResponseModel> PengeluaranStore(Pengeluaran pengeluaran)async {
    var _response = await http.post(Uri.parse(Api.instance.pengeluaranURL), body: {
      "kategori": pengeluaran.kategori,
      "sumber": pengeluaran.sumber,
      "jumlah": pengeluaran.jumlah,
      "catatan": pengeluaran.catatan,
      });
    print("$TAG, PengeluaranStore ${_response.statusCode}");
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
  Future<ResponseModel> PengeluaranUpdate(String id, Pengeluaran pengeluaran) async{
    var url = Api.instance.pengeluaranURL+"/"+id;

    var _response = await http.put(Uri.parse(url), body: {
      "kategori": pengeluaran.kategori,
      "sumber": pengeluaran.sumber,
      "jumlah": pengeluaran.jumlah,
      "catatan": pengeluaran.catatan,
    });
    print("$TAG, PengeluaranUpdate ${_response.statusCode}");
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
  Future<ResponseModel> PengeluaranDelete(String id) async {
    print("PengeluaranDelete $id");
    var _response = await http.delete(Uri.parse(Api.instance.pengeluaranURL+"/"+id));
    print("$TAG, PengeluaranDelete ${_response.statusCode}");
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

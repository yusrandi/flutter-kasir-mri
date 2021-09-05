import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:kasir_mri/config/api.dart';
import 'package:kasir_mri/models/response_model.dart';
import 'package:http/http.dart' as http;
import 'package:kasir_mri/models/transaksi_model.dart';


abstract class TransaksiRepository {
  Future<ResponseModel> transaksiStore(String total, String productId, String qty);
  Future<TransaksiModel> transaksiFetch();
  Future<TransaksiModel> transaksiFetchByDate(String startDate, String endDate);
}
class TransaksiRepositoryImpl implements TransaksiRepository{
  static const String TAG = "TransaksiRepositoryImpl";
  @override
  Future<ResponseModel> transaksiStore(String total, String productId, String qty) async{
    var _response = await http.post(Uri.parse(Api.instance.transaksiURL), body: {
      "total": total.toString(),
      "produk_id": productId,
      "qty": qty,
      "today": DateFormat('yyyy/MM/dd').format(DateTime.now().toLocal()).toString()
      });
    print("$TAG, TransaksiStore ${_response.statusCode}");
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
  Future<TransaksiModel> transaksiFetch() async{
    var _response = await http.get(Uri.parse(Api.instance.transaksiURL));
    print("$TAG, fetchTransaksis ${_response.statusCode}");
    if (_response.statusCode == 201) {
      print("$TAG fetchTransaksis true ");
      var data = json.decode(_response.body);
      print("Data $data");
      TransaksiModel model = TransaksiModel.fromJson(data);
      return model;
    } else {
      print("$TAG getLogin else");
      throw Exception();
    }
  }

  @override
  Future<TransaksiModel> transaksiFetchByDate(String startDate, String endDate) async {
    var _response = await http.post(Uri.parse(Api.instance.transaksiURL+"/bydate"), body: {
      'startDate' : startDate,
      'endDate' : endDate,
    });
    print("$TAG, transaksiFetchByDate ${_response.statusCode}");
    if (_response.statusCode == 201) {
      print("$TAG transaksiFetchByDate true ");
      var data = json.decode(_response.body);
      print("transaksiFetchByDate $data");
      TransaksiModel model = TransaksiModel.fromJson(data);
      return model;
    } else {
      print("$TAG transaksiFetchByDate else");
      throw Exception();
    }
  }
  
}

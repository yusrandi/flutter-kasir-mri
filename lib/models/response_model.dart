class ResponseModel {
  String responsecode = "";
  String responsemsg = "";

  ResponseModel({required this.responsecode, required this.responsemsg});

  ResponseModel.fromJson(Map<String, dynamic> json) {
    responsecode = json['responsecode'];
    responsemsg = json['responsemsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['responsecode'] = this.responsecode;
    data['responsemsg'] = this.responsemsg;
    return data;
  }
}

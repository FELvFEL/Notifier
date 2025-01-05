class Requisite {
  List<Data>? data;
  String? message;

  Requisite({this.data, this.message});

  Requisite.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  int? id;
  String? type;
  String? requisite;

  Data({this.id, this.type, this.requisite});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    requisite = json['requisite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['requisite'] = this.requisite;
    return data;
  }
}

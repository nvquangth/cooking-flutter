import 'package:cooking_flutter/data/model/category.dart';

class CategoryResponse {
  int status;
  String message;
  List<Category> categories;

  CategoryResponse.fromJsonMap(Map<String, dynamic> map)
      : status = map['status'],
        message = map['message'],
        categories = List<Category>.from(
            map['result'].map((it) => Category.fromJsonMap(it)));

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = status;
    data['message'] = message;
    data['result'] = categories != null
        ? this.categories.map((v) => v.toJson()).toList()
        : null;
    return data;
  }
}

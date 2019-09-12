import 'package:cooking_flutter/data/model/recipe.dart';

class CategoryDetailResponse {
  int status;
  String message;
  List<Recipe> recipes;

  CategoryDetailResponse.fromJsonMap(Map<String, dynamic> map)
      : status = map['status'],
        message = map['message'],
        recipes = List<Recipe>.from(
            map['result'].map((it) => Recipe.fromJsonMap(it)));

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = status;
    data['message'] = message;
    data['result'] =
        recipes != null ? this.recipes.map((v) => v.toJson()).toList() : null;
    return data;
  }
}

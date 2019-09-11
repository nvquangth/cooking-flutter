import 'package:cooking_flutter/data/model/recipe.dart';

class RecipeResponse {
  int status;
  String message;
  Recipe recipe;

  RecipeResponse.fromJsonMap(Map<String, dynamic> map)
      : status = map["status"],
        message = map["message"],
        recipe = Recipe.fromJsonMap(map["result"]);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = status;
    data['message'] = message;
    data['result'] = recipe == null ? null : recipe.toJson();
    return data;
  }
}

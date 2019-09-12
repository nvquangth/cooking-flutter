import 'package:cooking_flutter/data/model/recipe.dart';

class Category {
  String id;
  String name;
  int totalRecipe;
  List<String> images;
  List<Recipe> recipes;

  Category.fromJsonMap(Map<String, dynamic> map)
      : id = map["id"],
        name = map["name"],
        totalRecipe = map["total_recipes"],
        images = List<String>.from(map["images"]),
        recipes =
            map["recipes"] != null ? List<Recipe>.from(map["recipes"]) : null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['total_recipes'] = totalRecipe;
    data['images'] = images;
    data['recipes'] = recipes;
    return data;
  }
}

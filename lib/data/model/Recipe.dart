import 'package:cooking_flutter/data/model/Ingredient.dart';
import 'package:cooking_flutter/data/model/Step.dart';

class Recipe {
  String name;
  int time;
  String img;
  String level;
  String des;
  int serving;
  List<Ingredient> ingredients;
  List<Step> steps;

  Recipe.fromJsonMap(Map<String, dynamic> map)
      : name = map["name"],
        time = map["time"],
        img = map["img"],
        level = map["level"],
        des = map["des"],
        serving = map["serving"],
        ingredients = List<Ingredient>.from(
            map["components"].map((it) => Ingredient.fromJsonMap(it))),
        steps = List<Step>.from(
            map["cook_steps"].map((it) => Step.fromJsonMap(it)));

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = name;
    data['time'] = time;
    data['img'] = img;
    data['level'] = level;
    data['des'] = des;
    data['serving'] = serving;
    data['components'] = ingredients != null
        ? this.ingredients.map((v) => v.toJson()).toList()
        : null;
    data['cook_steps'] =
        steps != null ? this.steps.map((v) => v.toJson()).toList() : null;
    return data;
  }
}

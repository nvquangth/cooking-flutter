import 'package:cooking_flutter/data/model/component.dart';
import 'package:cooking_flutter/data/model/cook_step.dart';

class Recipe {
  String id;
  String name;
  int time;
  String level;
  int serving;
  String img;
  int totalComponent;
  int totalStep;
  List<Component> components;
  List<CookStep> cookSteps;

  Recipe.fromJsonMap(Map<String, dynamic> map)
      : id = map["id"],
        name = map["name"],
        time = map["time"],
        level = map["level"],
        serving = map["serving"],
        img = map["img"],
        totalComponent = map["total_components"],
        totalStep = map["total_steps"],
        components = List<Component>.from(
            map["components"].map((it) => Component.fromJsonMap(it))),
        cookSteps = List<CookStep>.from(
            map["cook_steps"].map((it) => CookStep.fromJsonMap(it)));

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['time'] = time;
    data['level'] = level;
    data['serving'] = serving;
    data['img'] = img;
    data['total_components'] = totalComponent;
    data['total_steps'] = totalStep;
    data['components'] = components != null
        ? this.components.map((v) => v.toJson()).toList()
        : null;
    data['cook_steps'] = cookSteps != null
        ? this.cookSteps.map((v) => v.toJson()).toList()
        : null;
    return data;
  }
}

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
  bool isFavorite;

  Recipe(
      {this.id,
      this.name,
      this.time,
      this.level,
      this.serving,
      this.img,
      this.totalComponent,
      this.totalStep,
      this.components,
      this.cookSteps,
      this.isFavorite});

  Recipe.fromJsonMap(Map<String, dynamic> map)
      : id = map["id"],
        name = map["name"],
        time = map["time"],
        level = map["level"],
        serving = map["serving"],
        img = map["img"],
        totalComponent = map["total_components"],
        totalStep = map["total_steps"],
        components = map["components"] != null
            ? List<Component>.from(
                map["components"].map((it) => Component.fromJsonMap(it)))
            : null,
        cookSteps = map["cook_steps"] != null
            ? List<CookStep>.from(
                map["cook_steps"].map((it) => CookStep.fromJsonMap(it)))
            : null;

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

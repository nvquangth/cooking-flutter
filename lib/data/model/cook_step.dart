class CookStep {
  List<String> pictures;
  int step;
  String des;

  CookStep.fromJsonMap(Map<String, dynamic> map)
      : pictures = List<String>.from(map["pictures"]),
        step = map["step"],
        des = map["des"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pictures'] = pictures;
    data['step'] = step;
    data['des'] = des;
    return data;
  }
}

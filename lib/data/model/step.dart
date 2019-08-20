class Step {
  String id;
  int step;
  String des;
  List<String> pictures;

  Step.fromJsonMap(Map<String, dynamic> map)
      : id = map["id"],
        step = map["step"],
        des = map["des"],
        pictures = List<String>.from(map["pictures"]);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['step'] = step;
    data['des'] = des;
    data['pictures'] = pictures;
    return data;
  }
}

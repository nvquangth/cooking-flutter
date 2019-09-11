class Component {
  String name;
  String quantity;
  String unit;

  Component.fromJsonMap(Map<String, dynamic> map)
      : name = map["name"],
        quantity = map["quantity"],
        unit = map["unit"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = name;
    data['quantity'] = quantity;
    data['unit'] = unit;
    return data;
  }
}

class Ingredient {
  String id;
  String name;
  String quantity;
  String unit;

  Ingredient.fromJsonMap(Map<String, dynamic> map)
      : id = map["id"],
        name = map["name"],
        quantity = map["quantity"],
        unit = map["unit"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['quantity'] = quantity;
    data['unit'] = unit;
    return data;
  }
}

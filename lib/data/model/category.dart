class Category {
  int id;
  String title;
  String source;
  int recipes;
  List<String> images;

  Category.fromJsonMap(Map<String, dynamic> map)
      : id = map["id"],
        title = map["title"],
        source = map["source"],
        recipes = map["recipes"],
        images = List<String>.from(map["images"]);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['title'] = title;
    data['source'] = source;
    data['recipes'] = recipes;
    data['images'] = images;
    return data;
  }
}

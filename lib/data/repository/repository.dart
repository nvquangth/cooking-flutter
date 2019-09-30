import 'dart:convert';

import 'package:cooking_flutter/data/constant/constant.dart';
import 'package:cooking_flutter/data/model/category.dart';
import 'package:cooking_flutter/data/model/category_response.dart';
import 'package:cooking_flutter/data/model/category_detail_response.dart';
import 'package:cooking_flutter/data/model/recipe.dart';
import 'package:cooking_flutter/data/model/recipe_response.dart';
import 'package:cooking_flutter/data/sqflite/db_helper.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';

abstract class Repository {
  Future<List<Category>> getCategories();

  Future<List<Recipe>> getRecipes();

  Future<List<Recipe>> getRecipesByCategory(String categoryId);

  Future<List<Recipe>> getRecipesByName(String name);

  Future<Recipe> getRecipeById(String recipeId);

  Future<void> insertRecipe(Recipe recipe);

  Future<void> updateRecipe(Recipe recipe);

  Future<void> deleteRecipe(Recipe recipe);

  Future<Recipe> getRecipeFromLocal(String recipeId);

  Future<List<Recipe>> getRecipesFromLocal();

  Future<List<Recipe>> getRecipesByNameFromLocal(String name);
}

class RepositoryImpl implements Repository {
  static RepositoryImpl _instance;
  final DbHelper dbHelper = DbHelper();

  factory RepositoryImpl() {
    if (_instance == null) {
      _instance = RepositoryImpl._internal();
    }
    return _instance;
  }

  RepositoryImpl._internal();

  @override
  Future<List<Category>> getCategories() async {
    final response = await http.get(_getFullUrl(Constant.ROUTE_CATEGORY));
    return _isSuccess(response)
        ? CategoryResponse.fromJsonMap(json.decode(response.body)).categories
        : throw Exception(Constant.PARAM_ERROR);
  }

  @override
  Future<List<Recipe>> getRecipes() {
    return null;
  }

  @override
  Future<List<Recipe>> getRecipesByCategory(String categoryId) async {
    final response =
        await http.get(_getFullUrl(Constant.ROUTE_CATEGORY) + "/$categoryId");
    return _isSuccess(response)
        ? CategoryDetailResponse.fromJsonMap(json.decode(response.body)).recipes
        : throw Exception(Constant.PARAM_ERROR);
  }

  @override
  Future<List<Recipe>> getRecipesByName(String name) async {
    final map = {"q": name};
    final response = await http.get(_uriPathQuery(Constant.ROUTE_RECIPE, map));
    return _isSuccess(response)
        ? CategoryDetailResponse.fromJsonMap(json.decode(response.body)).recipes
        : throw Exception(Constant.PARAM_ERROR);
  }

  @override
  Future<Recipe> getRecipeById(String recipeId) async {
    final response =
        await http.get(_getFullUrl(Constant.ROUTE_RECIPE) + "/$recipeId");
    return _isSuccess(response)
        ? RecipeResponse.fromJsonMap(json.decode(response.body)).recipe
        : throw Exception(Constant.PARAM_ERROR);
  }

  String _getFullUrl(String path) => Constant.BASE_URL + path;

  Uri _uriPathQuery(String path, Map<String, String> query) =>
      Uri.https(Constant.DOMAIN_URL, "$path", query);

  bool _isSuccess(http.Response response) {
    return response.statusCode >= 200 && response.statusCode < 300;
  }

  @override
  Future<void> deleteRecipe(Recipe recipe) async {
    Database db = await dbHelper.open();
    await db.delete('recipe', where: 'id = ?', whereArgs: [recipe.id]);
  }

  @override
  Future<List<Recipe>> getRecipesFromLocal() async {
    Database db = await dbHelper.open();
    List<Map<String, dynamic>> results =
        await db.rawQuery('SELECT * FROM recipe');

    List<Recipe> recipes = [];
    for (Map<String, dynamic> result in results) {
      recipes.add(_getRecipeFromRaw(result));
    }
    return recipes;
  }

  @override
  Future<void> insertRecipe(Recipe recipe) async {
    Database db = await dbHelper.open();

    var map = Map<String, dynamic>();
    map['id'] = recipe.id;
    map['name'] = recipe.name;
    map['time'] = recipe.time;
    map['level'] = recipe.level;
    map['serving'] = recipe.serving;
    map['img'] = recipe.img;
    map['total_component'] = recipe.totalComponent;
    map['total_step'] = recipe.totalStep;

    await db.insert('recipe', map,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> updateRecipe(Recipe recipe) async {
    Database db = await dbHelper.open();

    var map = Map<String, dynamic>();
    map['id'] = recipe.id;
    map['name'] = recipe.name;
    map['time'] = recipe.time;
    map['level'] = recipe.level;
    map['serving'] = recipe.serving;
    map['img'] = recipe.img;
    map['total_component'] = recipe.totalComponent;
    map['total_step'] = recipe.totalStep;

    await db.update('recipe', map,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<Recipe> getRecipeFromLocal(String recipeId) async {
    Database db = await dbHelper.open();

    List<Map<String, dynamic>> results =
        await db.rawQuery('SELECT * FROM recipe WHERE id = ?', [recipeId]);

    if (results == null || results.length == 0) {
      return null;
    }

    var result = results[0];
    return _getRecipeFromRaw(result);
  }

  @override
  Future<List<Recipe>> getRecipesByNameFromLocal(String name) async {
    Database db = await dbHelper.open();
    List<Map<String, dynamic>> results =
        await db.rawQuery("SELECT * FROM recipe WHERE name LIDE ?", [name]);
    List<Recipe> recipes = [];
    for (Map<String, dynamic> result in results) {
      recipes.add(_getRecipeFromRaw(result));
    }
    return recipes;
  }

  Recipe _getRecipeFromRaw(Map<String, dynamic> raw) {
    return Recipe(
        id: raw['id'],
        name: raw['name'],
        time: raw['time'],
        level: raw['level'],
        serving: raw['serving'],
        img: raw['img'],
        totalComponent: raw['total_component'],
        totalStep: raw['total_step']);
  }
}

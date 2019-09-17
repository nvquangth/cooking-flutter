import 'dart:convert';

import 'package:cooking_flutter/data/constant/constant.dart';
import 'package:cooking_flutter/data/model/category.dart';
import 'package:cooking_flutter/data/model/category_response.dart';
import 'package:cooking_flutter/data/model/category_detail_response.dart';
import 'package:cooking_flutter/data/model/recipe.dart';
import 'package:cooking_flutter/data/model/recipe_response.dart';
import 'package:http/http.dart' as http;

abstract class Repository {
  Future<List<Category>> getCategories();

  Future<List<Recipe>> getRecipes();

  Future<List<Recipe>> getRecipesByCategory(String categoryId);

  Future<List<Recipe>> getRecipesByName(String name);

  Future<Recipe> getRecipeById(String recipeId);
}

class RepositoryImpl implements Repository {
  static RepositoryImpl _instance;

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
  Future<List<Recipe>> getRecipesByName(String name) {
    // TODO: implement getRecipesByName
    return null;
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
      Uri.https(Constant.BASE_URL, "$path", query);

  bool _isSuccess(http.Response response) {
    return response.statusCode >= 200 && response.statusCode < 300;
  }
}

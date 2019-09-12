import 'package:cooking_flutter/data/repository/repository.dart';

class AppInjection {

//  static AppInjection _instance;
//
//  factory AppInjection() {
//    if (_instance == null) {
//      _instance = AppInjection();
//    }
//    return _instance;
//  }
//
//  AppInjection._internal();

  Repository provideRepository() => RepositoryImpl();

  final injection = AppInjection();
}
import 'package:cooking_flutter/data/model/category.dart';
import 'package:cooking_flutter/data/repository/repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'dart:async';

abstract class CategoryDetailEvent {

}

abstract class CategoryDetailState {

}

class CategoryDetailBloc extends Bloc<CategoryDetailEvent, CategoryDetailState> {
  @override
  // TODO: implement initialState
  CategoryDetailState get initialState => null;

  @override
  Stream<CategoryDetailState> mapEventToState(CategoryDetailEvent event) {
    // TODO: implement mapEventToState
    return null;
  }

}
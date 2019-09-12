import 'package:cooking_flutter/data/model/category.dart';
import 'package:cooking_flutter/data/repository/repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'dart:async';

abstract class HomeEvent {
}

class FetchHome extends HomeEvent {
}

class RefreshHome extends HomeEvent {
}

abstract class HomeState {
}

class HomeEmpty extends HomeState {
}

class HomeLoading extends HomeState {
}

class HomeLoaded extends HomeState {
  final List<Category> categories;

  HomeLoaded({@required this.categories});
}

class HomeError extends HomeState {
}

class HomeBloc extends Bloc<HomeEvent, HomeState> {

  final RepositoryImpl repository;

  HomeBloc({@required this.repository});

  @override
  HomeState get initialState => HomeEmpty();

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is FetchHome) {
      yield HomeLoading();

      try {
        final List<Category> categories = await repository.getCategories();

        yield HomeLoaded(categories: categories);
      } catch(e) {
        yield HomeError();
      }
    }

    if (event is RefreshHome) {

    }
  }

}
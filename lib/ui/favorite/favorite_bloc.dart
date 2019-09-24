import 'package:cooking_flutter/data/model/recipe.dart';
import 'package:cooking_flutter/data/repository/repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'dart:async';

abstract class FavoriteEvent {}

class FetchFavorite extends FavoriteEvent {}

class RefreshFavorite extends FavoriteEvent {}

abstract class FavoriteState {}

class FavoriteEmpty extends FavoriteState {}

class FavoriteLoading extends FavoriteState {}

class FavoriteLoaded extends FavoriteState {
  final List<Recipe> recipes;

  FavoriteLoaded({this.recipes});
}

class FavoriteError extends FavoriteState {}

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final RepositoryImpl repository;

  FavoriteBloc({@required this.repository});

  @override
  FavoriteState get initialState => FavoriteEmpty();

  @override
  Stream<FavoriteState> mapEventToState(FavoriteEvent event) async* {
    if (event is FetchFavorite) {
      yield FavoriteLoading();
    }

    try {
      final List<Recipe> recipes = await repository.getRecipesFromLocal();
      for (var recipe in recipes) {
        recipe.isFavorite = true;
      }

      yield FavoriteLoaded(recipes: recipes);
    } catch (_) {
      yield FavoriteError();
    }
  }
}

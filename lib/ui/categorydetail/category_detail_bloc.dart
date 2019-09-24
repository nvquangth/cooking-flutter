import 'package:cooking_flutter/data/model/category.dart';
import 'package:cooking_flutter/data/model/recipe.dart';
import 'package:cooking_flutter/data/repository/repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'dart:async';

abstract class CategoryDetailEvent {}

class FetchCategoryDetail extends CategoryDetailEvent {
  final String categoryId;

  FetchCategoryDetail({@required this.categoryId});
}

class RefreshCategoryDetail extends CategoryDetailEvent {
  final String categoryId;

  RefreshCategoryDetail({@required this.categoryId});
}

abstract class CategoryDetailState {}

class CategoryDetailEmpty extends CategoryDetailState {}

class CategoryDetailLoading extends CategoryDetailState {}

class CategoryDetailLoaded extends CategoryDetailState {
  final List<Recipe> recipes;

  CategoryDetailLoaded({@required this.recipes});
}

class CategoryDetailError extends CategoryDetailState {}

class CategoryDetailBloc
    extends Bloc<CategoryDetailEvent, CategoryDetailState> {
  final RepositoryImpl repository;
  final Category category;

  CategoryDetailBloc({@required this.repository, @required this.category});

  @override
  CategoryDetailState get initialState => CategoryDetailEmpty();

  @override
  Stream<CategoryDetailState> mapEventToState(
      CategoryDetailEvent event) async* {
    if (event is FetchCategoryDetail) {
      yield CategoryDetailLoading();
    }

    try {
      final List<Recipe> recipes =
          await repository.getRecipesByCategory(category.id);

      for (final recipe in recipes) {
        final rl = await repository.getRecipeFromLocal(recipe.id);

        if (rl != null) {
          recipe.isFavorite = true;
        } else {
          recipe.isFavorite = false;
        }
      }

      yield CategoryDetailLoaded(recipes: recipes);
    } catch (_) {
      yield CategoryDetailError();
    }
  }
}

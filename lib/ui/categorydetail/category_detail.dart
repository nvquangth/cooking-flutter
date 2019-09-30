import 'dart:async';

import 'package:cooking_flutter/data/model/category.dart';
import 'package:cooking_flutter/data/model/recipe.dart';
import 'package:cooking_flutter/data/repository/repository.dart';
import 'package:cooking_flutter/ui/categorydetail/category_detail_bloc.dart';
import 'package:cooking_flutter/ui/recipedetail/recipe_detail.dart';
import 'package:cooking_flutter/ui/recipedetail/recipe_detail_bloc.dart';
import 'package:cooking_flutter/ui/search/search.dart';
import 'package:cooking_flutter/ui/search/search_bloc.dart';
import 'package:cooking_flutter/utils/app_colors.dart';
import 'package:cooking_flutter/utils/app_images.dart';
import 'package:cooking_flutter/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryDetail extends StatefulWidget {
  final Category category;

  CategoryDetail({@required this.category});

  @override
  State<CategoryDetail> createState() => _CategoryDetailState();
}

class _CategoryDetailState extends State<CategoryDetail> {
  Category category;
  Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();
    category = widget.category;
    _refreshCompleter = Completer<void>();
  }

  @override
  Widget build(BuildContext context) {
    final categoryDetailBloc = BlocProvider.of<CategoryDetailBloc>(context);
    categoryDetailBloc.dispatch(FetchCategoryDetail(categoryId: category.id));

    return Scaffold(
      appBar: AppBar(
        title: Text("${category.name} (${category.totalRecipe} món)"),
        backgroundColor: AppColors.colorPrimary,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: _onSearchClick,
          )
        ],
      ),
      body: _buildBody(categoryDetailBloc),
    );
  }

  Widget _buildBody(CategoryDetailBloc bloc) {
    return BlocListener<CategoryDetailBloc, CategoryDetailState>(
      listener: (context, state) {
        if (state is CategoryDetailLoaded || state is CategoryDetailError) {
          _refreshCompleter?.complete();
          _refreshCompleter = Completer();
        }
      },
      child: BlocBuilder<CategoryDetailBloc, CategoryDetailState>(
        builder: (context, state) {
          if (state is CategoryDetailLoaded) {
            final recipes = state.recipes;

            return RefreshIndicator(
              child: ListView.builder(
                  itemCount: recipes.length,
                  itemBuilder: (context, index) {
                    return _buildItemRecipe(recipes, index);
                  }),
              onRefresh: () {
                bloc.dispatch(RefreshCategoryDetail(categoryId: category.id));
                return _refreshCompleter.future;
              },
            );
          }

          if (state is CategoryDetailError) {
            return RefreshIndicator(
              child: ListView(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 16.0, bottom: 8.0, left: 64.0, right: 64.0),
                        child: Text(
                          AppStrings.msg_no_data_refresh,
                          textAlign: TextAlign.center,
                          style: TextStyle(),
                        ),
                      ),
                      RaisedButton(
                        onPressed: () {
                          bloc.dispatch(
                              FetchCategoryDetail(categoryId: category.id));
                        },
                        child: Text(AppStrings.title_reload_data),
                      )
                    ],
                  )
                ],
              ),
              onRefresh: () {
                bloc.dispatch(FetchCategoryDetail(categoryId: category.id));
                return _refreshCompleter.future;
              },
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget _buildItemRecipe(List<Recipe> recipes, int index) {
    final recipe = recipes[index];

    return GestureDetector(
      onTap: () {
        _onItemRecipeClick(recipe);
      },
      child: Container(
        height: 200.0,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            FadeInImage.assetNetwork(
              placeholder: AppImages.default_image_large,
              image: recipe.img,
              fit: BoxFit.cover,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 72.0,
                color: AppColors.color_transparent_48,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, bottom: 8.0, right: 8.0, top: 8.0),
                      child: Text(
                        recipe.name,
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                        maxLines: 1,
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 4.0),
                          child: Icon(
                            Icons.alarm,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '${recipe.time} phút',
                          style: TextStyle(color: Colors.white),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 16.0, right: 4.0),
                          child: Icon(
                            Icons.group,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '${recipe.serving} người',
                          style: TextStyle(color: Colors.white),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 16.0, right: 4.0),
                          child: Icon(
                            Icons.list,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '${recipe.totalComponent} nguyên liệu',
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: recipe.isFavorite
                    ? Icon(
                        Icons.favorite,
                        color: Colors.white,
                      )
                    : Container(),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onItemRecipeClick(Recipe recipe) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => BlocProvider(
              builder: (context) => RecipeDetailBloc(
                  repository: RepositoryImpl(), recipe: recipe),
              child: RecipeDetail(),
            )));
  }

  void _onSearchClick() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => BlocProvider(
              builder: (context) => SearchBloc(repository: RepositoryImpl()),
              child: Search(),
            )));
  }
}

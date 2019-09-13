import 'dart:async';

import 'package:cooking_flutter/data/model/category.dart';
import 'package:cooking_flutter/data/model/recipe.dart';
import 'package:cooking_flutter/ui/categorydetail/category_detail_bloc.dart';
import 'package:cooking_flutter/utils/app_colors.dart';
import 'package:cooking_flutter/utils/app_strings.dart';
import 'package:flutter/cupertino.dart';
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
          children: <Widget>[
            Image.network(
              recipe.img,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }

  void _onItemRecipeClick(Recipe recipe) {}
}

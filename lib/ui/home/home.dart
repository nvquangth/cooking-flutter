import 'dart:async';
import 'dart:math';

import 'package:cooking_flutter/data/constant/constant.dart';
import 'package:cooking_flutter/data/model/category.dart';
import 'package:cooking_flutter/data/repository/repository.dart';
import 'package:cooking_flutter/ui/categorydetail/category_detail.dart';
import 'package:cooking_flutter/ui/categorydetail/category_detail_bloc.dart';
import 'package:cooking_flutter/ui/favorite/favorite.dart';
import 'package:cooking_flutter/ui/favorite/favorite_bloc.dart';
import 'package:cooking_flutter/ui/home/home_bloc.dart';
import 'package:cooking_flutter/utils/app_colors.dart';
import 'package:cooking_flutter/utils/app_images.dart';
import 'package:cooking_flutter/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
  }

  @override
  Widget build(BuildContext context) {
    final homeBloc = BlocProvider.of<HomeBloc>(context);
    homeBloc.dispatch(FetchHome());

    return Scaffold(
      appBar: _buildAppBar(),
      drawer: _buildDrawer(homeBloc),
      body: _buildBody(homeBloc),
    );
  }

  Widget _buildBody(HomeBloc homeBloc) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is HomeLoaded || state is HomeError) {
          _refreshCompleter?.complete();
          _refreshCompleter = Completer();
        }
      },
      child: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
        if (state is HomeLoaded) {
          final categories = state.categories;

          return RefreshIndicator(
            child: GridView.count(
              crossAxisCount: 2,
              children: List.generate(categories.length, (index) {
                return _buildItemCategory(categories, index);
              }),
            ),
            onRefresh: () {
              homeBloc.dispatch(RefreshHome());
              return _refreshCompleter.future;
            },
          );
        }
        if (state is HomeError) {
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
                        homeBloc.dispatch(FetchHome());
                      },
                      child: Text(AppStrings.title_reload_data),
                    )
                  ],
                )
              ],
            ),
            onRefresh: () {
              homeBloc.dispatch(RefreshHome());
              return _refreshCompleter.future;
            },
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      }),
    );
  }

  Widget _buildItemCategory(List<Category> categories, int index) {
    final category = categories[index];

    final widthScreen = MediaQuery.of(context).size.width;
    final space = 4.0;

    final widthItem = widthScreen / 2 - space * 4;

    final paddingLeft = index % 2 != 0 ? space / 2 : space;
    final paddingRight = index % 2 == 0 ? space / 2 : space;
    final paddingTop = space;
    final paddingBottom = index == (categories.length - 1) ? space : 0.0;

    return GestureDetector(
      onTap: () {
        _onItemCategoryClick(category, false);
      },
      child: Padding(
        padding: EdgeInsets.only(
            top: paddingTop,
            bottom: paddingBottom,
            left: paddingLeft,
            right: paddingRight),
        child: Container(
          width: widthItem,
          height: widthItem,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  Constant.BASE_URL + category.images[Random().nextInt(3)],
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 64.0,
                  decoration: BoxDecoration(
                      color: AppColors.color_transparent_48,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8.0),
                          bottomRight: Radius.circular(8.0))),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          category.name.toUpperCase(),
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          category.totalRecipe.toString() + " món",
                          style: TextStyle(fontSize: 16.0, color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text(AppStrings.title_toolbar_categories),
      backgroundColor: AppColors.colorPrimary,
    );
  }

  Widget _buildDrawer(HomeBloc homeBloc) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Image.asset(
              AppImages.drawer,
              height: 140.0,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          ListTile(
            title: Text(AppStrings.title_favorite),
            leading: Icon(
              Icons.favorite,
              color: AppColors.colorPrimary,
            ),
            onTap: _onFavoriteClick,
          ),
          ListTile(
            title: Text(AppStrings.title_search),
            leading: Icon(
              Icons.search,
              color: AppColors.colorPrimary,
            ),
            onTap: _onSearchClick,
          ),
          Container(
            height: 1.0,
            color: AppColors.color_gray_400,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 16.0),
            child: Text(
              AppStrings.title_categories.toUpperCase(),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: AppColors.color_gray_600),
            ),
          ),
          Expanded(child:
              BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
            if (state is HomeLoaded) {
              final categories = state.categories;

              return ListView.separated(
                  padding: EdgeInsets.only(top: 8.0),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        _onItemCategoryClick(categories[index], true);
                      },
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Icon(
                              Icons.label,
                              color: AppColors.colorAccent,
                            ),
                          ),
                          Expanded(
                            child: Text(categories[index].name),
                          )
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => Divider(
                        color: AppColors.color_gray_600,
                      ),
                  itemCount: categories.length);
            }
            if (state is HomeError) {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(AppStrings.msg_no_data),
                    ),
                    RaisedButton(
                      onPressed: () {
                        homeBloc.dispatch(FetchHome());
                      },
                      child: Text(AppStrings.title_reload_data),
                    )
                  ],
                ),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          })),
          ListTile(
            title: Text(AppStrings.title_rate_me),
            leading: Icon(
              Icons.thumb_up,
              color: AppColors.colorPrimary,
            ),
            onTap: _onRateMeClick,
          ),
          ListTile(
            title: Text(AppStrings.title_feedback),
            leading: Icon(
              Icons.feedback,
              color: AppColors.colorPrimary,
            ),
            onTap: _onFeedbackClick,
          ),
        ],
      ),
    );
  }

  void _onFavoriteClick() {
    Navigator.pop(context);

    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => BlocProvider(
            builder: (context) => FavoriteBloc(repository: RepositoryImpl()),
            child: Favorite())));
  }

  void _onSearchClick() {}

  void _onRateMeClick() {}

  void _onFeedbackClick() {}

  void _onItemCategoryClick(Category category, bool fromDrawer) {
    if (fromDrawer) {
      Navigator.pop(context);
    }

    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => BlocProvider(
              builder: (context) => CategoryDetailBloc(
                  repository: RepositoryImpl(), category: category),
              child: CategoryDetail(
                category: category,
              ),
            )));
  }
}

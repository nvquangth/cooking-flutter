import 'package:cooking_flutter/utils/app_colors.dart';
import 'package:cooking_flutter/utils/app_images.dart';
import 'package:cooking_flutter/utils/app_strings.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _Home(),
    );
  }
}

class _Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: _buildDrawer(),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text("Cooking"),
    );
  }

  Widget _buildDrawer() {
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
          Expanded(
              child: ListView.separated(
                  padding: EdgeInsets.only(top: 8.0),
                  itemBuilder: (context, index) {
                    return GestureDetector(
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
                            child: Text("Test"),
                          )
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => Divider(
                        color: AppColors.color_gray_600,
                      ),
                  itemCount: 20)),
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

  void _onFavoriteClick() {}

  void _onSearchClick() {}

  void _onRateMeClick() {}

  void _onFeedbackClick() {}
}

import 'package:audiobook/ui/screens/Tab-1/models/musicModel.dart';
import 'package:audiobook/ui/screens/Tab-3/bookmarkScreen.dart';
import 'package:audiobook/ui/shared/appBar.dart';
import 'package:audiobook/ui/shared/controllers/userController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pagination_view/pagination_view.dart';

class BrowsingHistoryScreen extends StatelessWidget {
  final String title;

  BrowsingHistoryScreen({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(title: title),
        body: GetBuilder(builder: (UserController controller) {
          return PaginationView(
            itemBuilder:
                (BuildContext context, MusicModel musicModel, int index) =>
                    GetMoreViewList(searchModel: musicModel, index: index,listMusicModel:controller.historyMusics),
            pageFetch: controller.getHistory,
            pullToRefresh: true,
            physics: BouncingScrollPhysics(),
            onEmpty: Center(
              child: Text('no_data_found'.tr),
            ),
            onError: (error) {
              return Center(child: Text(error));
            },
          );
        }));
  }
}

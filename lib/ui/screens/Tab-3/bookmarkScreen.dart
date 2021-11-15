import 'package:audiobook/core/constant/appSettings.dart';
import 'package:audiobook/core/utils/config.dart';
import 'package:audiobook/ui/screens/Tab-1/homeScreen.dart';
import 'package:audiobook/ui/screens/Tab-1/models/musicModel.dart';
import 'package:audiobook/ui/screens/Tab-2/widgets/workDetails.dart';
import 'package:audiobook/ui/shared/controllers/userController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookMarkScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(builder: (UserController controller) {
      List<MusicModel> musicModel = controller.getBookmark();
      if (musicModel.isEmpty) {
        return Center(child: Text('no_data_found'.tr));
      } else
        return Column(
          children: [
            ListView.builder(
              itemCount: musicModel.length,
              itemBuilder: (context, index) {
                return GetMoreViewList(
                  searchModel: musicModel[index],
                  index: index,
                  listMusicModel: musicModel,
                );
              },
            ),
            getSizedBox(h: 90),
          ],
        );
    });
  }
}

class GetMoreViewList extends StatelessWidget {
  final MusicModel searchModel;
  final int index;
  final List<MusicModel> listMusicModel;

  const GetMoreViewList(
      {Key? key,
      required this.searchModel,
      required this.index,
      required this.listMusicModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(
            () => WorkDetails(
                  musicModel: searchModel,
                  musicModelList: listMusicModel,
                ),
            transition: Transition.rightToLeftWithFade);
      },
      child: Container(
        color: Colors.transparent,
        margin: EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 85,
              width: 85,
              decoration: BoxDecoration(
                  color: Colors.black12.withOpacity(0.20),
                  borderRadius: BorderRadius.circular(kBorderRadius),
                  image: DecorationImage(
                      image: NetworkImage(searchModel.image),
                      fit: BoxFit.cover)),
            ),
            getSizedBox(w: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getSizedBox(h: 15),
                  Text(
                    searchModel.title,
                    maxLines: 1,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: getWidth(13)),
                  ),
                  getSizedBox(h: 7),
                  Text(
                    searchModel.desc,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: TextStyle(fontSize: getWidth(11)),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

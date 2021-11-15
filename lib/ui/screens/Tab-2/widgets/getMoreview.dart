import 'package:audiobook/core/constant/appSettings.dart';
import 'package:audiobook/core/utils/config.dart';
import 'package:audiobook/ui/screens/Tab-1/homeScreen.dart';
import 'package:audiobook/ui/screens/Tab-1/models/musicModel.dart';
import 'package:audiobook/ui/screens/Tab-2/widgets/workDetails.dart';
import 'package:audiobook/ui/shared/appBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GetMoreViewAboutSearch extends StatelessWidget {
  final List<MusicModel> searchModel;
  final String text;
  const GetMoreViewAboutSearch(
      {Key? key, required this.searchModel, required this.text})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: text),
      body: ListView.builder(
          physics: BouncingScrollPhysics(),
          padding: const EdgeInsets.only(top: kDefaultPadding - 5),
          itemCount: searchModel.length,
          itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  Get.to(() => WorkDetails(
                        musicModel: searchModel[index],
                        musicModelList: searchModel,
                      ), transition: Transition.rightToLeftWithFade);
                },
                child: Container(
                  color: Colors.transparent,
                  margin: EdgeInsets.symmetric(
                      horizontal: kDefaultPadding, vertical: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 85,
                        width: 85,
                        decoration: BoxDecoration(
                            color: Colors.black12.withOpacity(0.20),
                            borderRadius: BorderRadius.circular(kBorderRadius),
                            image:DecorationImage(
                                image: NetworkImage(searchModel[index].image),
                                fit: BoxFit.cover)
                        ),
                      ),
                      getSizedBox(w: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            getSizedBox(h: 15),
                            Text(
                              searchModel[index].title,
                              maxLines: 1,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: getWidth(13)),
                            ),
                            getSizedBox(h: 7),
                            Text(
                              searchModel[index].desc,
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
              )),
    );
  }
}

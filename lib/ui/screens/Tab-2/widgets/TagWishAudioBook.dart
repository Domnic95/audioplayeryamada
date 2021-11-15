import 'package:audiobook/core/constant/appSettings.dart';
import 'package:audiobook/core/utils/config.dart';
import 'package:audiobook/ui/screens/Tab-1/controllers/homeScreenController.dart';
import 'package:audiobook/ui/screens/Tab-1/models/musicModel.dart';
import 'package:audiobook/ui/screens/Tab-2/models/SearchTag.dart';
import 'package:audiobook/ui/screens/Tab-2/widgets/workDetails.dart';
import 'package:audiobook/ui/shared/appBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TagWishAudioBook extends StatelessWidget {
  SearchTagImageUrl searchTag;
  TagWishAudioBook({required this.searchTag});
  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.put(HomeController());
    return Scaffold(
      appBar: appbarWithText(searchTag.tag),
      body: FutureBuilder<List<MusicModel>>(
          future: homeController.getDataBytTag(searchTag.tag),
          builder: (context, snap) {
            if (snap.hasData) {
              print(snap.data!.length);
              return snap.data!.length == 0
                  ? Center(
                      child: Text('No Event Found'),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 5),
                      child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          padding:
                              EdgeInsets.symmetric(horizontal: kDefaultPadding),
                          // scrollDirection: Axis.horizontal,
                          itemCount: snap.data!.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(
                                      () => WorkDetails(
                                          musicModel: snap.data![index],
                                          musicModelList: snap.data!),
                                      transition:
                                          Transition.rightToLeftWithFade);
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        snap.data![index].image,
                                        width: 81,
                                        height: 81,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Flexible(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 20,),
                                          Text(
                                            snap.data![index].title,
                                            maxLines: 2,
                                            style: TextStyle(
                                              fontSize: getWidth(13),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),

                                        ],
                                      )
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
                    );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}

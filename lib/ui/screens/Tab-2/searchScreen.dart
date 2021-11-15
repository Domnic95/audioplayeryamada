import 'package:audiobook/core/constant/appSettings.dart';
import 'package:audiobook/core/utils/config.dart';
import 'package:audiobook/ui/screens/Tab-1/controllers/homeScreenController.dart';
import 'package:audiobook/ui/screens/Tab-1/homeScreen.dart';

import 'package:audiobook/ui/screens/Tab-1/models/TagsModel.dart';
import 'package:audiobook/ui/screens/Tab-1/models/musicModel.dart';
import 'package:audiobook/ui/screens/Tab-2/controllers/searchControlller.dart';
import 'package:audiobook/ui/screens/Tab-2/models/SearchTag.dart';
import 'package:audiobook/ui/screens/Tab-2/models/actormodel.dart';
import 'package:audiobook/ui/screens/Tab-2/models/scenarioModel.dart';
import 'package:audiobook/ui/screens/Tab-2/models/searchModel.dart';
import 'package:audiobook/ui/screens/Tab-2/widgets/TagWishAudioBook.dart';
import 'package:audiobook/ui/screens/Tab-2/widgets/getMoreview.dart';
import 'package:audiobook/ui/screens/Tab-2/widgets/workDetails.dart';
import 'package:audiobook/ui/shared/headerview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pagination_view/pagination_view.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final SearchController searchController = Get.find<SearchController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // final SearchController searchController = Get.put(SearchController());
    return SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: FutureBuilder(
            future: searchController.fetchTag(),
            builder: (context, snap) {
              if (searchController.searchTag.length != 0) {
                //   return Text(snapshot.data!.length.toString());
                return Column(children: [
                  for (int i = 0; i < searchController.searchTag.length; i++)
                    Column(
                      children: [
                        getSizedBox(h: 25),
                        header(
                          searchController.searchTag[i].title.toString(),
                        ),
                        getSizedBox(h: 12),
                        SizedBox(
                          height: 180,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount:
                                    searchController.searchTag[i].tag.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Get.to(TagWishAudioBook(
                                        searchTag: searchController
                                            .searchTag[i].tag[index],
                                      ));
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          right: kDefaultPadding),
                                      width: 125,
                                      decoration: BoxDecoration(
                                          color:
                                              Colors.black12.withOpacity(0.20),
                                          borderRadius: BorderRadius.circular(
                                              kBorderRadius),
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  searchController.searchTag[i]
                                                      .tag[index].url),
                                              fit: BoxFit.cover)),
                                      child: Container(
                                        padding: EdgeInsets.only(left: 12),
                                        decoration: BoxDecoration(
                                          color:
                                              Colors.black12.withOpacity(0.20),
                                          borderRadius: BorderRadius.circular(
                                              kBorderRadius),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "#" +
                                                searchController.searchTag[i]
                                                    .tag[index].tag,
                                            maxLines: 3,
                                            style: TextStyle(
                                                fontSize: getWidth(13),
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        )
                      ],
                    )
                ]);
              } else {
                return Container(
                    height: size.height,
                    child: Center(child: CircularProgressIndicator()));
              }
            }));
  }

  Widget tagRow(
      MusicModel musicList, List<MusicModel> tagList, SearchTag SearchTag) {
    return HomeContent(
      onTap: () {
        Get.to(
            () => WorkDetails(musicModel: musicList, musicModelList: tagList),
            transition: Transition.rightToLeftWithFade);
      },
      musicModel: musicList,
    );
  }

  SizedBox viewOfPagination(
      {required Future<List<MusicModel>> Function(int) pageFetch,
      required Function widget}) {
    return SizedBox(
      height: 180,
      child: PaginationView<MusicModel>(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
        onError: (error) {
          return Center(child: Text(error));
        },
        pageFetch: pageFetch,
        itemBuilder: (BuildContext context, MusicModel musicModel, int) {
          return widget(musicModel);
        },
        onEmpty: Center(
          child: Text('No Event Found'),
        ),
      ),
    );
  }
}

class ListBoxForSearch extends StatelessWidget {
  final String title;
  final String image;
  final double width;
  final double? height;
  final Function()? onTap;

  const ListBoxForSearch({
    Key? key,
    required this.title,
    required this.image,
    this.width = 125,
    this.height,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 180,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            margin: EdgeInsets.only(right: kDefaultPadding),
            width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kBorderRadius),
              // image: DecorationImage(
              //     image: NetworkImage(image,),
              //     fit: BoxFit.cover)
            ),
            child: Stack(
              children: [
                Image.network(
                  image,
                  width: width,
                  height: 180,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (BuildContext context, Object a, StackTrace? strack) {
                    return Text('');
                  },
                ),
                Container(
                  padding: EdgeInsets.only(left: 12),
                  decoration: BoxDecoration(
                    color: Colors.black12.withOpacity(0.50),
                    borderRadius: BorderRadius.circular(kBorderRadius),
                  ),
                  child: Center(
                    child: Text(
                      "#$title",
                      style: TextStyle(
                          fontSize: getWidth(13),
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

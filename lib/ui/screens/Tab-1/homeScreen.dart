import 'package:audio_service/audio_service.dart';
import 'package:audiobook/core/constant/appImages.dart';
import 'package:audiobook/core/constant/appSettings.dart';
import 'package:audiobook/core/utils/config.dart';
import 'package:audiobook/ui/screens/Tab-1/controllers/homeScreenController.dart';
import 'package:audiobook/ui/screens/Tab-1/models/TagsModel.dart';
import 'package:audiobook/ui/screens/Tab-1/models/musicModel.dart';
import 'package:audiobook/ui/screens/Tab-2/controllers/searchControlller.dart';
import 'package:audiobook/ui/screens/Tab-2/models/actormodel.dart';
import 'package:audiobook/ui/screens/Tab-2/widgets/getMoreview.dart';
import 'package:audiobook/ui/screens/Tab-2/widgets/workDetails.dart';
import 'package:audiobook/ui/shared/controllers/baseScreenController.dart';
import 'package:audiobook/ui/shared/headerview.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pagination_view/pagination_view.dart';

import '../../../global.dart';
import '../musicPlaySheet.dart';

class HomeScreen extends StatelessWidget {
  final HomeController homeController = Get.put(HomeController());
  final SearchController searchController = Get.put(SearchController());
  final BaseScreenController baseScreenController =
      Get.find<BaseScreenController>();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
        // no need to initialize Controller ever again, just mention the type
        builder: (value) => SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  getSizedBox(h: 30),
                  //  firstRow(),
                  CustomListView(
                      function: homeController.getMusicListFeatures(),
                      list: homeController.features,
                      width: Get.width - 100),
                  /*commonItem(homeController.getMusicListFeatures(),
                      homeController.features, Get.width - 100),*/
                  // viewOfPagination(
                  //     pageFetch: homeController.getMusicListFeatures,
                  //     widget: featureItemRow),
                  getSizedBox(h: 25),
                  header(
                    'views_ranking'.tr,
                  ),
                  getSizedBox(h: 12),
                  CustomListView(
                      function: homeController.getMusicListRankWise(),
                      list: homeController.rankWiseMusic,
                      width: 125),
                  // commonItem(homeController.getMusicListRankWise(),
                  //     homeController.rankWiseMusic, 125),
                  // viewOfPagination(
                  //     pageFetch: homeController.getMusicListRankWise,
                  //     widget: viewRankingRow),
                  getSizedBox(h: 25),
                  header(
                    'new_arrival'.tr,
                  ),
                  getSizedBox(h: 12),
                  CustomListView(
                      function: homeController.getMusicListNewArrival(),
                      list: homeController.newArrival,
                      width: 125),
                  // commonItem(homeController.getMusicListNewArrival(),
                  //     homeController.newArrival, 125),
                  // viewOfPagination(
                  //     pageFetch: homeController.getMusicListNewArrival,
                  //     widget: newArrivalRow),
                  getSizedBox(h: 25),
                  // header(
                  //   'voice_actor_name'.tr,
                  // ),
                  // getSizedBox(h: 12),
                  // SizedBox(
                  //   height: 180,
                  //   child: PaginationView<ActorModel>(
                  //     scrollDirection: Axis.horizontal,
                  //     physics: BouncingScrollPhysics(),
                  //     padding:
                  //         EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  //     onError: (error) {
                  //       return Center(child: Text(error));
                  //     },
                  //     pageFetch: searchController.getListByVoiceActor,
                  //     itemBuilder: (BuildContext context, ActorModel actorModel,
                  //         int index) {
                  //       return voiceActorName(
                  //           actorModel.musicModel[0], actorModel);
                  //     },
                  //     onEmpty: Center(
                  //       child: Text('No Event Found'),
                  //     ),
                  //   ),
                  // ),

                  for (int i = 0; i < homeController.tagsModel.length; i++)
                    Column(
                      children: [
                        getSizedBox(h: 25),
                        header(
                          homeController.tagsModel[i].title.toString(),
                        ),
                        getSizedBox(h: 12),
                        SizedBox(
                          height: 180,
                          child: FutureBuilder<List<MusicModel>>(
                              future: homeController.getDataBytTag(
                                  homeController.tagsModel[i].tag),
                              builder: (context, snap) {
                                if (snap.hasData) {
                                  print(snap.data!.length);
                                  return snap.data!.length == 0
                                      ? Center(
                                          child: Text('No Event Found'),
                                        )
                                      : ListView.builder(
                                          physics: BouncingScrollPhysics(),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: kDefaultPadding),
                                          scrollDirection: Axis.horizontal,
                                          itemCount: snap.data!.length,
                                          itemBuilder: (context, index) {
                                            return tagRow(
                                              snap.data![index],
                                              snap.data!,
                                              homeController.tagsModel[i],
                                            );
                                          });
                                } else {
                                  return Center(
                                      child:
                                      //Text(snap.error.toString())
                                       CircularProgressIndicator()
                                  );
                                }
                              }),
                        )
                      ],
                    )

                  // getSizedBox(h: 12),
                  // header(
                  //   'taro'.tr,
                  // ),
                  // getSizedBox(h: 12),
                  // viewOfPagination(
                  //     pageFetch: homeController.getTaroMusicList, widget: taroRow),
                ],
              ),
            ));
  }

  SizedBox viewOfPagination(
      {required Future<List<MusicModel>> Function(
        int,
      )
          pageFetch,
      required Function widget}) {
    return SizedBox(
      height: 180,
      child: PaginationView<MusicModel>(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
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

  Widget featureItemRow(
    MusicModel musicList,
  ) {
    return ListBox(
      onTap: () {
        Get.to(
            () => WorkDetails(
                musicModel: musicList, musicModelList: homeController.features),
            transition: Transition.rightToLeftWithFade);
      },
      width: Get.width - 100,
      musicModel: musicList,
    );
  }

  Widget viewRankingRow(MusicModel musicList) {
    return ListBox(
      onTap: () {
        Get.to(
            () => WorkDetails(
                musicModel: musicList,
                musicModelList: homeController.rankWiseMusic),
            transition: Transition.rightToLeftWithFade);
      },
      musicModel: musicList,
    );
  }

  Widget newArrivalRow(MusicModel musicList) {
    return ListBox(
      onTap: () {
        Get.to(
            () => WorkDetails(
                musicModel: musicList,
                musicModelList: homeController.newArrival),
            transition: Transition.rightToLeftWithFade);
      },
      musicModel: musicList,
    );
  }

  Widget tagRow(
      MusicModel musicList, List<MusicModel> tagList, TagsModel tagsModel) {
    return HomeContent(
      onTap: () {
        Get.to(
            () => WorkDetails(musicModel: musicList, musicModelList: tagList),
            transition: Transition.rightToLeftWithFade);
      },
      musicModel: musicList,
    );
  }

  Widget voiceActorName(MusicModel musicModel, ActorModel actorModel) {
    return ListBox(
      onTap: () {
        Get.to(
            () => GetMoreViewAboutSearch(
                  searchModel: actorModel.musicModel,
                  text: actorModel.title,
                ),
            transition: Transition.rightToLeftWithFade);
      },
      musicModel: musicModel,
    );
  }
}

class PlayControlBox extends StatelessWidget {
  const PlayControlBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        openMusicPlaySheet();
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border:
                Border(top: BorderSide(color: Color(0xffD8D8D8), width: 1))),
        padding:
            EdgeInsets.only(left: kDefaultPadding, right: kDefaultPadding - 5),
        child: Row(
          children: [
            StreamBuilder<MediaItem?>(
                stream: audioHandler.mediaItem,
                builder: (_, snapshot) {
                  final MediaItem? mediaItem = snapshot.data;
                  return Expanded(
                    child: Row(
                      children: [
                        Container(
                          height: 45,
                          width: 45,
                          decoration: mediaItem?.artUri == null
                              ? BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(AppImages.tent2)))
                              : BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          mediaItem?.artUri.toString() as String),
                                      fit: BoxFit.cover)),
                        ),
                        getSizedBox(w: 20),
                        Expanded(
                          child: Text(

                            (currentMusicModelTrackIndex == 0
                                    ? ""
                                    : currentMusicModelTrackIndex.toString() +
                                        " ") +
                                (mediaItem?.title ?? "Title"), maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                            style: TextStyle(

                                fontSize: getWidth(13),
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            getSizedBox(w: 20),
            playPauseButton()
          ],
        ),
      ),
    );
  }

  Widget playPauseButton() {
    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) =>
          StreamBuilder<PlaybackState>(
              stream: audioHandler.playbackState,
              builder: (context, snapshot) {
                final tempPlayerId = audioHandler.mediaItem.value?.id ?? "";
                final playbackState = snapshot.data;
                final processingState = playbackState?.processingState;
                final playing = playbackState?.playing;
                if (tempPlayerId ==
                    currentMusicModel!.track[currentMusicModelTrackIndex].url) {
                  if (processingState == AudioProcessingState.loading ||
                      processingState == AudioProcessingState.buffering) {
                    return Container(
                      margin: const EdgeInsets.all(8.0),
                      width: 40,
                      height: 40,
                      child: const CircularProgressIndicator(),
                    );
                  } else if (playing != true) {
                    return IconButton(
                      icon: const Icon(Icons.play_arrow),
                      iconSize: 40,
                      color: Colors.black,
                      onPressed: () {
                        print("PLAY");
                        audioPlayerHandlerImpl.updateCurrentPlayerData(
                            currentMusicModel!, currentMusicModelTrackIndex);
                      },
                    );
                  } else {
                    return IconButton(
                      icon: const Icon(Icons.pause),
                      iconSize: 40,
                      color: Colors.black,
                      onPressed: () {
                        print("PAUSE");
                        audioHandler.pause();
                      },
                    );
                  }
                } else {
                  return IconButton(
                    icon: const Icon(Icons.play_arrow),
                    iconSize: 40,
                    color: Colors.black,
                    onPressed: () {
                      print("NOT PLAYING");
                      audioPlayerHandlerImpl.updateCurrentPlayerData(
                          currentMusicModel!, currentMusicModelTrackIndex);
                    },
                  );
                }
              }),
    );
  }
}

class ListBox extends StatelessWidget {
  final MusicModel musicModel;
  final double width;
  final double? height;
  final Function()? onTap;

  const ListBox(
      {Key? key,
      this.width = 125,
      this.height,
      this.onTap,
      required this.musicModel})
      : super(key: key);

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
                color: Colors.black12.withOpacity(0.20),
                borderRadius: BorderRadius.circular(kBorderRadius),
                image: DecorationImage(
                    image: NetworkImage(musicModel.image), fit: BoxFit.cover)),
            child: Container(
              padding: EdgeInsets.only(left: 12),
              decoration: BoxDecoration(
                color: Colors.black12.withOpacity(0.20),
                borderRadius: BorderRadius.circular(kBorderRadius),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spacer(),
                  Text(
                    musicModel.title,
                    maxLines: 3,
                    style: TextStyle(
                        fontSize: getWidth(13),
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  getSizedBox(h: 15),
                  Text(
                    musicModel.desc,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        TextStyle(fontSize: getWidth(11), color: Colors.white),
                  ),
                  getSizedBox(h: 15),
                ],
              ),
            ),
          )),
    );
  }
}

class HomeContent extends StatelessWidget {
  final MusicModel musicModel;
  final double width;
  final double? height;
  final Function()? onTap;

  const HomeContent({
    Key? key,
    this.width = 125,
    this.height,
    this.onTap,
    required this.musicModel,
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
                color: Colors.black12.withOpacity(0.20),
                borderRadius: BorderRadius.circular(kBorderRadius),
                image: DecorationImage(
                    image: NetworkImage(musicModel.image), fit: BoxFit.cover)),
            child: Container(
              padding: EdgeInsets.only(left: 12),
              decoration: BoxDecoration(
                color: Colors.black12.withOpacity(0.20),
                borderRadius: BorderRadius.circular(kBorderRadius),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spacer(),
                  Text(
                    musicModel.title,
                    maxLines: 3,
                    style: TextStyle(
                        fontSize: getWidth(13),
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  getSizedBox(h: 15),
                  Text(
                    musicModel.desc,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        TextStyle(fontSize: getWidth(11), color: Colors.white),
                  ),
                  getSizedBox(h: 15),
                ],
              ),
            ),
          )),
    );
  }
}

class CustomListView extends StatelessWidget {
  Future function;
  List<MusicModel> list;
  double width;
  final HomeController homeController = Get.put(HomeController());
  CustomListView(
      {required this.function, required this.list, required this.width});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 180,
        child: FutureBuilder(
            future: function,
            builder: (context, snap) {
              return list.length == 0
                  ? Center(
                      child: !snap.hasData
                          ? CircularProgressIndicator()
                          : Text('No Event Found'),
                    )
                  : ListView.builder(
                      physics: BouncingScrollPhysics(),
                      padding:
                          EdgeInsets.symmetric(horizontal: kDefaultPadding),
                      scrollDirection: Axis.horizontal,
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        return customMusicModel(list[index], width);
                      });
              // } else {
              //   return Center(child: CircularProgressIndicator());
              // }
            }));
  }

  Widget customMusicModel(MusicModel musicList, double width) {
    return ListBox(
      onTap: () {
        Get.to(
            () => WorkDetails(
                musicModel: musicList,
                musicModelList: homeController.newArrival),
            transition: Transition.rightToLeftWithFade);
      },
      musicModel: musicList,
      width: width,
    );
  }
}

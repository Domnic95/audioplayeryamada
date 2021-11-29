import 'package:audio_service/audio_service.dart';
import 'package:audiobook/core/constant/appColors.dart';
import 'package:audiobook/core/constant/appSettings.dart';
import 'package:audiobook/core/services/audioBookRepo.dart';
import 'package:audiobook/core/utils/config.dart';
import 'package:audiobook/ui/screens/Tab-1/homeScreen.dart';

import 'package:audiobook/ui/screens/Tab-1/models/musicModel.dart';
import 'package:audiobook/ui/screens/Tab-2/controllers/workDetailControll.dart';
import 'package:audiobook/ui/screens/Tab-2/widgets/audioPlayer/trackList.dart';
import 'package:audiobook/ui/screens/login/loginScreen.dart';
import 'package:audiobook/ui/screens/login/trialAskingScreen.dart';
import 'package:audiobook/ui/shared/appBar.dart';
import 'package:audiobook/ui/shared/appButton/customButtonextension.dart';
import 'package:audiobook/ui/shared/appButton/custombutton.dart';
import 'package:audiobook/ui/shared/controllers/userController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Rx;
import 'package:just_audio/just_audio.dart';
import 'package:readmore/readmore.dart';

import '../../../../global.dart';
import '../../../../main.dart';
import '../../musicPlaySheet.dart';

class WorkDetails extends StatefulWidget {
  final MusicModel musicModel;
  final List<MusicModel> musicModelList;
  WorkDetails(
      {Key? key, required this.musicModel, required this.musicModelList})
      : super(key: key);
  @override
  _WorkDetailsState createState() => _WorkDetailsState();
}

class _WorkDetailsState extends State<WorkDetails> {
  final WorkDetailController workDetailController =
      Get.put(WorkDetailController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('intliaze');


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: ''),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(left: kDefaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(right: kDefaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getSizedBox(h: 25),
                    coverPhoto(),
                    getSizedBox(h: 25),
                    Text(
                      widget.musicModel.title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: getWidth(18)),
                    ),
                    getSizedBox(h: 20),
                    Text(
                      widget.musicModel.desc,
                      style: TextStyle(
                          color: AppColor.kDefaultGreyText,
                          fontSize: getWidth(13)),
                    ),
                    getSizedBox(h: 35),
                    playPauseButton(widget.musicModel),
                    getSizedBox(h: 10),
                    bookmarkButton(widget.musicModel),
                    getSizedBox(h: 35),
                    header('about_this_work'.tr),
                    getSizedBox(h: 10),
                    aboutWork(),
                    getSizedBox(h: 20),
                    header('cv'.tr),
                    getSizedBox(h: 10),
                    aboutCv(),
                  ],
                ),
              ),
              getSizedBox(h: 20),
              header('track'.tr),
              getSizedBox(h: 10),
              TrackList(false, widget.musicModel),
              //TrackPlayer( widget.musicModel),
              getSizedBox(h: 35),
              header('related_works'.tr),
              getSizedBox(h: 12),
              remainingLists(),
              getSizedBox(h: 30),
            ],
          ),
        ),
      ),
    );
  }

  coverPhoto() {
    return Container(
        height: getHeight(250),
        width: Get.width,
        decoration: BoxDecoration(
            color: Colors.black12.withOpacity(0.20),
            image: DecorationImage(
                image: NetworkImage(widget.musicModel.image),
                fit: BoxFit.cover)));
  }

  Column aboutCv() {
    return Column(
      children: List.generate(
          widget.musicModel.cv.length,
          (index) => Text(
                widget.musicModel.cv[index],
                style: TextStyle(
                    fontSize: getWidth(10), color: AppColor.kDefaultGreyText),
              )),
    );
  }

  ReadMoreText aboutWork() {
    return ReadMoreText(
      widget.musicModel.about,
      trimLines: 2,
      lessStyle: TextStyle(
          fontSize: getWidth(10),
          color: AppColor.kBarTextColor,
          fontWeight: FontWeight.bold),
      trimMode: TrimMode.Line,
      trimCollapsedText: 'show_all'.tr,
      trimExpandedText: 'show_less'.tr,
      style: TextStyle(
        fontSize: getWidth(10),
        color: AppColor.kDefaultGreyText,
      ),
      moreStyle: TextStyle(
          fontSize: getWidth(10),
          color: AppColor.kBarTextColor,
          fontWeight: FontWeight.bold),
    );
  }

  Center bookmarkButton(MusicModel musicModel) {
    return Center(
      child: Container(
        width: getWidth(240),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GetBuilder(
              builder: (UserController controller) => controller
                      .userInformation.bookmark
                      .contains(musicModel.id)
                  ? CustomButton(
                      type: CustomButtonType.colourButton,
                      text: 'bookMark'.tr,
                      radius: 4,
                      width: getWidth(115),
                      height: 29,
                      onTap: () {
                        print('bookmark');
                        if (FirebaseInstance.firebaseAuth!.currentUser ==
                                null ||
                            FirebaseInstance
                                .firebaseAuth!.currentUser!.isAnonymous) {
                          Get.to(() => LoginScreen(),
                              transition: Transition.rightToLeftWithFade);
                        } else {
                          userController.unBookMark(id: widget.musicModel.id);
                        }
                      })
                  : CustomButton(
                      type: CustomButtonType.borderButton,
                      text: 'bookMark'.tr,
                      radius: 4,
                      width: getWidth(115),
                      height: 29,
                      onTap: () {
                        print('bookmark');
                        if (FirebaseInstance.firebaseAuth!.currentUser ==
                                null ||
                            FirebaseInstance
                                .firebaseAuth!.currentUser!.isAnonymous) {
                          Get.to(() => LoginScreen(),
                              transition: Transition.rightToLeftWithFade);
                        } else {
                          userController.addBookMark(id: widget.musicModel.id);
                        }
                      }),
            ),
            CustomButton(
              type: CustomButtonType.borderButton,
              text: 'listen_to_a_sample'.tr,
              radius: 4,
              width: getWidth(115),
              height: 29,
              onTap: () async {
                print('audioPlayer');
                await AudioBookRepo().sampleAudio(widget.musicModel);

                //audioHandler.play();
              },
              // widget: Container(
              //   margin: const EdgeInsets.all(8.0),
              //   width: 22,
              //   height: 22,
              //   child: const CircularProgressIndicator(),
              // ),
            ),
          ],
        ),
      ),
    );
  }

  Widget playPauseButton(MusicModel musicModel) {
    return StreamBuilder<PlaybackState>(
        stream: audioHandler.playbackState,
        builder: (context, snapshot) {
          final playbackState = snapshot.data;
          final processingState = playbackState?.processingState;
          final playing = playbackState?.playing;
          if (currentQueueId == musicModel.id) {
            if (processingState == AudioProcessingState.loading ||
                processingState == AudioProcessingState.buffering) {
              return Center(
                child: CustomButton(
                  type: CustomButtonType.colourButton,
                  text: "",
                  radius: 9,
                  width: getWidth(240),
                  onTap: () async {},
                  widget: Container(
                    margin: const EdgeInsets.all(8.0),
                    width: 22,
                    height: 22,
                    child: const CircularProgressIndicator(),
                  ),
                ),
              );
            } else if (playing != true) {
              return playButton();
            } else {
              return pauseButton();
            }
          } else {
            return playButton();
          }
        });
  }

  Widget pauseButton() {
    return Center(
      child: CustomButton(
        type: CustomButtonType.colourButton,
        text: "",
        radius: 9,
        width: getWidth(240),
        onTap: () {
          print("PAUSE");


          audioHandler.pause();
        },
        widget: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.pause_circle_outline,
                color: Colors.white,
              ),
            ),
            Center(
              child: Text(
                'pause'.tr,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: getWidth(14),
                    color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget playButton() {
    return Center(
      child: CustomButton(
        type: CustomButtonType.colourButton,
        text: "",
        radius: 9,
        width: getWidth(240),
        onTap: () async {
          if(!userController.userInformation.inSubscription){
            if(FirebaseInstance.firebaseAuth!.currentUser == null){
              Get.to(() => LoginScreen(),
                  transition: Transition.downToUp);
            }else{
              Get.to(() => TrialAskingScreen(),
                  transition: Transition.downToUp);
            }

          }else{
            await AudioBookRepo().firebaseCounter(widget.musicModel);
            if(audioPlayer.playing){
              audioPlayer.stop();
            }
            userController.addHistory(id: widget.musicModel.id);
            print("NOT PLAY");



            audioPlayerHandlerImpl.updateCurrentPlayerData(
                widget.musicModel,
                currentQueueId == widget.musicModel.id
                    ? currentMusicModelTrackIndex
                    : 0);
            openMusicPlaySheet();
          }

        },
        widget: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.play_circle_outline,
                color: Colors.white,
              ),
            ),
            Center(
              child: Text(
                'play'.tr,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: getWidth(14),
                    color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Text header(String text) {
    return Text(
      text,
      style: TextStyle(
          color: AppColor.kDefaultGreyText,
          fontWeight: FontWeight.bold,
          fontSize: getWidth(13)),
    );
  }

  // List<MusicModel> get list {
  //   return  widget.musicModelList
  //       .where((element) => element.id !=  widget.musicModel.id)
  //       .toList();
  // }

  SizedBox remainingLists() {
    // List<MusicModel> list = [];

    return SizedBox(
        height: 180,
        child: ListView.builder(
            itemCount: widget.musicModelList.length,
            physics: BouncingScrollPhysics(),
            clipBehavior: Clip.none,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return widget.musicModelList[index].id == widget.musicModel.id
                  ? Container()
                  : ListBox(
                      musicModel: widget.musicModelList[index],
                      onTap: () {
                        Get.back();
                        Get.to(
                            () => WorkDetails(
                                musicModel: widget.musicModelList[index],
                                musicModelList: widget.musicModelList),
                            transition: Transition.rightToLeftWithFade);
                      },
                    );
            }));
  }
}

// class{
//   String imageUrl,track
// }

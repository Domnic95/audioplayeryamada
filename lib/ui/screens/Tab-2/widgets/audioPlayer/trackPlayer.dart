import 'package:audio_service/audio_service.dart';
import 'package:audiobook/core/constant/appColors.dart';
import 'package:audiobook/core/constant/appSettings.dart';
import 'package:audiobook/core/utils/config.dart';
import 'package:audiobook/ui/screens/Tab-1/models/musicModel.dart';
import 'package:audiobook/ui/screens/Tab-2/widgets/audioPlayer/seekbar.dart';
import 'package:audiobook/ui/screens/login/loginScreen.dart';
import 'package:audiobook/ui/shared/controllers/userController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../global.dart';
import '../../../../../main.dart';
import 'audioPlayerHandler.dart';
import 'positionDataModel.dart';
import 'package:share/share.dart';

class TrackPlayer extends StatelessWidget {
  final MusicModel musicModel;
  const TrackPlayer(this.musicModel);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // A seek bar.
        StreamBuilder<PositionData>(
          stream: PositionData.positionDataStream,
          builder: (context, snapshot) {
            PositionData positionData = snapshot.data ??
                PositionData(Duration.zero, Duration.zero, Duration.zero);
            return SeekBar(
              duration: positionData.duration,
              position: positionData.position,
              onChangeEnd: (newPosition) {
                audioHandler.seek(newPosition);
              },
            );
          },
        ),
        getSizedBox(h: 10),
        StreamBuilder<MediaItem?>(
            stream: audioHandler.mediaItem,
            builder: (_, snapshot) {
              final MediaItem? mediaItem = snapshot.data;

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      musicModel.title,
                      // mediaItem?.title ?? "Title",
                      style: TextStyle(
                          fontSize: getWidth(18), fontWeight: FontWeight.bold),
                    ),
                    getSizedBox(h: 10),
                    Text(
                      musicModel.desc,
                      // mediaItem?.displayDescription ?? "Description",
                      style: TextStyle(
                          fontSize: getWidth(13),
                          color: AppColor.kDefaultGreyText),
                    ),
                  ],
                ),
              );
            }),
        getSizedBox(h: 20),
        ControlButtons(musicModel),
      ],
    );
  }
}

class ControlButtons extends StatelessWidget {
  final MusicModel musicModel;

  ControlButtons(this.musicModel);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StreamBuilder<QueueState>(
              stream: audioHandler.queueState,
              builder: (context, snapshot) {
                final queueState = snapshot.data ?? QueueState([], null, []);
                return IconButton(
                  icon: const Icon(
                    Icons.skip_previous,
                    size: 35,
                  ),
                  onPressed: queueState.hasPrevious
                      ? () {
                          int index = queueState.queueIndex ?? 1;
                          // currentPlayerId = musicModel.track[index - 1].url;
                          currentMusicModelTrackIndex = index + 1;
                          audioHandler.skipToPrevious();
                        }
                      : null,
                );
              },
            ),
            StreamBuilder<PositionData>(
              stream: PositionData.positionDataStream,
              builder: (context, snapshot) {
                final tempPlayerId = audioHandler.mediaItem.value?.id ?? "";
                PositionData positionData = snapshot.data ??
                    PositionData(Duration.zero, Duration.zero, Duration.zero);
                return IconButton(
                    onPressed: () {
                      int milliSeconds =
                          (positionData.position.inSeconds - 10) * 1000;
                      if (milliSeconds < 0) milliSeconds = 0;
                      print(
                          "${positionData.position.inMilliseconds} ${milliSeconds}");
                      audioHandler.seek(Duration(milliseconds: milliSeconds));
                    },
                    iconSize: 40,
                    icon: Icon(
                      Icons.replay_10,
                    ));
              },
            ),
            StreamBuilder<PlaybackState>(
              stream: audioHandler.playbackState,
              builder: (context, snapshot) {
                final playbackState = snapshot.data;
                final processingState = playbackState?.processingState;
                final playing = playbackState?.playing;
                if (processingState == AudioProcessingState.loading ||
                    processingState == AudioProcessingState.buffering) {
                  return Container(
                    margin: const EdgeInsets.all(8.0),
                    width: 60.0,
                    height: 60.0,
                    child: const CircularProgressIndicator(),
                  );
                } else if (playing != true) {
                  return IconButton(
                      icon: const Icon(Icons.play_arrow),
                      iconSize: 60.0,
                      color: Colors.black,
                      onPressed: () {
                        userController.addHistory(id: musicModel.id);
                        audioHandler.play();
                        userController.update();
                      });
                } else {
                  return IconButton(
                    icon: const Icon(Icons.pause),
                    iconSize: 60.0,
                    color: Colors.black,
                    onPressed: audioHandler.pause,
                  );
                }
              },
            ),
            StreamBuilder<PositionData>(
              stream: PositionData.positionDataStream,
              builder: (context, snapshot) {
                final tempPlayerId = audioHandler.mediaItem.value?.id ?? "";
                PositionData positionData = snapshot.data ??
                    PositionData(Duration.zero, Duration.zero, Duration.zero);
                return IconButton(
                    onPressed: () {
                      int milliSeconds =
                          (positionData.position.inSeconds + 30) * 1000;
                      if (milliSeconds > positionData.duration.inMilliseconds)
                        milliSeconds = 0;
                      print(
                          "${positionData.position.inMilliseconds} ${milliSeconds}");
                      audioHandler.seek(Duration(milliseconds: milliSeconds));
                    },
                    iconSize: 40,
                    icon: Icon(
                      Icons.forward_30,
                    ));
              },
            ),
            StreamBuilder<QueueState>(
              stream: audioHandler.queueState,
              builder: (context, snapshot) {
                final queueState = snapshot.data ?? QueueState([], null, []);
                return IconButton(
                  icon: const Icon(
                    Icons.skip_next,
                    size: 35,
                  ),
                  onPressed: queueState.hasNext
                      ? () {
                          int index = queueState.queueIndex ?? 0;
                          // currentPlayerId = musicModel.track[index + 1].url;
                          currentMusicModelTrackIndex = index + 1;
                          audioHandler.skipToNext();
                        }
                      : null,
                );
              },
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              StreamBuilder<double>(
                stream: audioHandler.speed,
                builder: (context, snapshot) => GestureDetector(
                  child: Text("${snapshot.data?.toStringAsFixed(1)}x speed",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColor.kDefaultGreyText)),
                  onTap: () {
                    showSliderDialog(
                      context: context,
                      title: "Adjust speed",
                      divisions: 10,
                      min: 0.5,
                      max: 1.5,
                      value: audioHandler.speed.value,
                      stream: audioHandler.speed,
                      onChanged: audioHandler.setSpeed,
                    );
                  },
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: GetBuilder(
                  builder: (UserController controller) => IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        print('bookmark');
                        if (FirebaseInstance.firebaseAuth!.currentUser ==
                                null ||
                            FirebaseInstance
                                .firebaseAuth!.currentUser!.isAnonymous) {
                          Get.to(() => LoginScreen(),
                              transition: Transition.rightToLeftWithFade);
                        } else {
                          userController.addBookMark(id: musicModel.id);
                        }
                      },
                      constraints: BoxConstraints.loose(Size(25, 25)),
                      icon: Icon(
                        controller.userInformation.bookmark
                                .contains(musicModel.id)
                            ? Icons.bookmark
                            : Icons.bookmark_border_outlined,
                        color: controller.userInformation.bookmark
                                .contains(musicModel.id)
                            ? AppColor.kBarTextColor
                            : AppColor.kDefaultGreyText,
                      )),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                    onPressed: () {
                      Track track =
                          musicModel.track[currentMusicModelTrackIndex];
                      Share.share("https://bit.ly/3DfOkQV",
                          subject: track.name);
                    },
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints.loose(Size(25, 25)),
                    icon: Icon(
                      Icons.share,
                      color: Color(0xff979797),
                    )),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

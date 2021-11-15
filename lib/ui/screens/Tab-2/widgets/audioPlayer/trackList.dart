import 'package:audio_service/audio_service.dart';
import 'package:audiobook/core/constant/appColors.dart';
import 'package:audiobook/core/utils/config.dart';
import 'package:audiobook/main.dart';
import 'package:audiobook/ui/screens/Tab-1/models/musicModel.dart';
import 'package:audiobook/ui/screens/Tab-2/widgets/audioPlayer/progressbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../global.dart';
import '../../../musicPlaySheet.dart';
import 'positionDataModel.dart';

class TrackList extends StatelessWidget {
  final MusicModel musicModel;
  final bool isFromSheet;
  TrackList(this.isFromSheet, this.musicModel);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(musicModel.track.length, (index) {
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom:
                          BorderSide(color: Color(0xff9C9C9C), width: 0.3))),
              child: Row(
                children: [
                  Text(
                    "${index + 1}",
                    style: TextStyle(
                        color: AppColor.kDefaultGreyText,
                        fontWeight: FontWeight.bold,
                        fontSize: getWidth(13)),
                  ),
                  getSizedBox(w: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StreamBuilder<MediaItem?>(
                            stream: audioHandler.mediaItem,
                            builder: (_, snapshot) {
                              final MediaItem? mediaItem = snapshot.data;
                              return Text(
                                musicModel.track[index].name,
                                style: TextStyle(
                                    fontWeight: musicModel.track[index].name ==
                                            mediaItem?.title
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: AppColor.kDefaultGreyText,
                                    fontSize: getWidth(11)),
                              );
                            }),
                        StreamBuilder<PositionData>(
                          stream: PositionData.positionDataStream,
                          builder: (context, snapshot) {
                            final tempPlayerId =
                                audioHandler.mediaItem.value?.id ?? "";
                            PositionData positionData = snapshot.data ??
                                PositionData(Duration.zero, Duration.zero,
                                    Duration.zero);
                            if (tempPlayerId != musicModel.track[index].url)
                              positionData = PositionData(
                                  Duration.zero,
                                  Duration.zero,
                                  Duration(
                                      milliseconds:
                                          musicModel.track[index].duration));
                            return ProgressBar(
                              duration: positionData.duration,
                              position: positionData.position,
                              onChangeEnd: (newPosition) {
                                if (tempPlayerId == musicModel.track[index].url)
                                  audioHandler.seek(newPosition);
                              },
                            );
                          },
                        )
                      ],
                    ),
                  ),
                  getSizedBox(w: 30),
                ],
              ),
            ),
            StreamBuilder<PlaybackState>(
                stream: audioHandler.playbackState,
                builder: (context, snapshot) {
                  final tempPlayerId = audioHandler.mediaItem.value?.id ?? "";
                  final playbackState = snapshot.data;
                  final processingState = playbackState?.processingState;
                  final playing = playbackState?.playing;
                  if (tempPlayerId == musicModel.track[index].url) {
                    if (processingState == AudioProcessingState.loading ||
                        processingState == AudioProcessingState.buffering) {
                      return Container(
                          width: Get.width,
                          height: 50,
                          padding: EdgeInsets.only(left: Get.width - 50),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 3),
                            child: const CircularProgressIndicator(),
                          ));
                    } else if (playing != true) {
                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          userController.addHistory(id: musicModel.id);
                          print("PLAY");
                          audioPlayerHandlerImpl.updateCurrentPlayerData(
                              musicModel, index);
                          if (!isFromSheet) openMusicPlaySheet();
                        },
                        child: Container(
                            // color: Colors.white.withOpacity(0.1),
                            width: Get.width,
                            height: 50,
                            padding: EdgeInsets.only(left: Get.width - 50),
                            child: Icon(Icons.play_circle_outline,
                                size: 22, color: AppColor.kBarButtonColor)),
                      );
                    } else {
                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          print("PAUSE");
                          audioHandler.pause();
                        },
                        child: Container(
                            // color: Colors.white.withOpacity(0.1),
                            width: Get.width,
                            height: 50,
                            padding: EdgeInsets.only(left: Get.width - 50),
                            child: Icon(Icons.pause_circle_outline,
                                size: 22, color: AppColor.kBarButtonColor)),
                      );
                    }
                  } else {
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        print("NOT PLAYING");
                        audioPlayerHandlerImpl.updateCurrentPlayerData(
                            musicModel, index);
                        if (!isFromSheet) openMusicPlaySheet();
                      },
                      child: Container(
                          // color: Colors.white.withOpacity(0.1),
                          width: Get.width,
                          height: 50,
                          padding: EdgeInsets.only(left: Get.width - 50),
                          child: Icon(Icons.play_circle_outline,
                              size: 22, color: AppColor.kBarButtonColor)),
                    );
                  }
                }),
          ],
        );
      }),
    );
  }
}

import 'package:audio_service/audio_service.dart';
import 'package:audiobook/core/constant/appIcons.dart';
import 'package:audiobook/core/constant/appImages.dart';
import 'package:audiobook/core/constant/appSettings.dart';
import 'package:audiobook/core/utils/config.dart';
import 'package:audiobook/global.dart';
import 'package:audiobook/ui/screens/Tab-2/widgets/audioPlayer/trackPlayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'Tab-2/widgets/audioPlayer/trackList.dart';

Future<void> openMusicPlaySheet() async {
  return Get.bottomSheet(
    Container(
      height: Get.height - 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(10), topLeft: Radius.circular(12)),
        color: Colors.white,
      ),
      child: BottomSheetFun(),
    ),
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(10), topLeft: Radius.circular(12))),
    isScrollControlled: true,
  );
}

class BottomSheetFun extends StatefulWidget {
  @override
  _BottomSheetFunState createState() => _BottomSheetFunState();
}

class _BottomSheetFunState extends State<BottomSheetFun> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: IconButton(
            icon: SvgPicture.asset(AppIcons.backArrow),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        Expanded(
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              getSizedBox(h: 10),
              StreamBuilder<MediaItem?>(
                  stream: audioHandler.mediaItem,
                  builder: (_, snapshot) {
                    final MediaItem? mediaItem = snapshot.data;
                    return Center(
                      child: Container(
                        height: getWidth(230),
                        width: getWidth(230),
                        decoration: mediaItem?.artUri == null
                            ? BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                      AppImages.tent2,
                                    ),
                                    fit: BoxFit.cover))
                            : BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(
                                        mediaItem?.artUri.toString() as String),
                                    fit: BoxFit.cover)),
                      ),
                    );
                  }),
              getSizedBox(h: 30),
              TrackPlayer(currentMusicModel!),
              getSizedBox(h: 30),
              Padding(
                padding: const EdgeInsets.only(left: kDefaultPadding),
                child: TrackList(true, currentMusicModel!),
              ),
              getSizedBox(h: 30),
            ],
          ),
        )
      ],
    );
  }

  //
}

import 'package:audio_service/audio_service.dart';
import 'package:audiobook/core/services/InApp_Purchase.dart';
import 'package:audiobook/global.dart';
import 'package:audiobook/ui/screens/baseScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'core/constant/appThemes.dart';
import 'core/services/purchaseApi.dart';
import 'core/utils/localizationService.dart';
import 'ui/screens/Tab-2/widgets/audioPlayer/audioPlayerHandler.dart';
import 'ui/shared/controllers/userController.dart';

final UserController userController = Get.put(UserController());
PurchaseService purchaseService = PurchaseService();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseInstance.firebaseAuth = FirebaseAuth.instance;
  // await FirebaseAuth.instance.signInAnonymously();
  // store this in a singleton
 await globalListInit();
  audioPlayerHandlerImpl = AudioPlayerHandlerImpl();
  await purchaseService.initialize();
  await purchaseService.fetchData();

  audioHandler = await AudioService.init(
    builder: () => audioPlayerHandlerImpl,
    config: AudioServiceConfig(
      androidNotificationChannelId: 'jp.esituation.app.channel',
      androidNotificationChannelName: 'e-situAtion Playback',
      androidNotificationOngoing: true,
    ),
  );

  userController.getUserDetail();
    audioHandler.mediaItem.listen((event) {
        AlertDialog(content: Text('here'));


    });


  // await PurchaseApi.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return GetMaterialApp(
      title: 'e-situAtion',
      translations: LocalizationService(context),
      theme: AppTheme.defTheme,
      debugShowCheckedModeBanner: false,
      locale:  Locale('ja', 'JP'),
      // locale: LocalizationService.locale,


      fallbackLocale: LocalizationService.fallbackLocale,
      home: BaseScreen(),
    );
  }
}

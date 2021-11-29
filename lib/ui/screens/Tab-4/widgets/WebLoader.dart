import 'dart:io';
import 'package:audiobook/core/constant/appColors.dart';
import 'package:flutter/material.dart';

import 'package:webview_flutter/webview_flutter.dart';

import 'package:get/get.dart';
class WebViewLoader extends StatefulWidget {
  String url;
  String title;
  WebViewLoader({
    required    this.url,
    required this.title
});
  @override
  WebViewLoaderState createState() => WebViewLoaderState();
}

class WebViewLoaderState extends State<WebViewLoader> {
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
automaticallyImplyLeading: true,
        leading:IconButton(
          onPressed: (){
            Get.back();
          },
          icon: Icon(Icons.arrow_back,color: Colors.black,),

        ),
        title: Text(widget.title,style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: AppColor.kBarTextColor
        ),),
      ),
      body: WebView(
        initialUrl: widget.url,

      ),
    );
  }
}
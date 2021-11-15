import 'package:audiobook/core/constant/appColors.dart';
import 'package:audiobook/core/constant/appSettings.dart';
import 'package:audiobook/core/utils/config.dart';
import 'package:flutter/material.dart';

header(String title, {bool iconShow = false}) {
  return Padding(
    padding: const EdgeInsets.only(left: kDefaultPadding, right: 5),
    child: Row(
      children: [
        Text(
          title,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: getWidth(13.5),
              color: AppColor.kDefaultGreyText),
        ),
        // Spacer(),
        // iconShow
        //     ? IconButton(
        //         splashRadius: 15,
        //         constraints:
        //             BoxConstraints.loose(Size(getWidth(30), getWidth(30))),
        //         onPressed: () {},
        //         icon: SvgPicture.asset(AppIcons.forwardedArrow))
        //     : SizedBox()
      ],
    ),
  );
}

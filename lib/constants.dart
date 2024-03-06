import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

String kHostIP = "http://10.0.2.2:8000";

AlertDialog kCloseAppDialog() => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text("are you sure you want to quit the app?".tr),
      actions: [
        TextButton(
            onPressed: () => SystemNavigator.pop(),
            child: Text(
              "yes",
              //style: kTextStyle20.copyWith(color: Colors.red),
            )),
        TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text(
              "no".tr,
              //style: kTextStyle20,
            )),
      ],
    );

AlertDialog kSessionExpiredDialog() => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text("your session has expired please login again".tr),
      actions: [
        TextButton(
            onPressed: () {},
            child: Text(
              "yes".tr,
              //style: kTextStyle20.copyWith(color: Colors.red),
            )),
      ],
    );

Future kTimeOutDialog() => Get.defaultDialog(
      title: "error".tr,
      middleText: "operation is taking so long, please check your internet "
              "connection or try again later."
          .tr,
    );

import 'package:purchases_flutter/purchases_flutter.dart';

class SubscriptionPlan {
  int price;
  int subscriptionMonth;
  String month;
  Package? package;
  SubscriptionPlan(
      {required this.month,
      required this.price,
      required this.subscriptionMonth,
      required this.package});
}

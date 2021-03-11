import 'dart:io';

import 'package:app_review/app_review.dart';

class ReviewUtils {
  ReviewUtils._();

  static void requestReview() {
    if (Platform.isIOS) {
      AppReview.requestReview.then((onValue) {
        print(onValue);
      });
    }
  }
}

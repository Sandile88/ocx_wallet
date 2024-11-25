// Place fonts/pay.ttf in your fonts/ directory and
// add the following to your pubspec.yaml
// flutter:
//   fonts:
//    - family: pay
//      fonts:
//       - asset: fonts/pay.ttf
import 'package:flutter/widgets.dart';

class Pay {
  Pay._();

  static const String _fontFamily = 'pay';

  static const IconData pay_filled = IconData(0xe900, fontFamily: _fontFamily);
}

// Place fonts/deposit.ttf in your fonts/ directory and
// add the following to your pubspec.yaml
// flutter:
//   fonts:
//    - family: deposit
//      fonts:
//       - asset: fonts/deposit.ttf
import 'package:flutter/widgets.dart';

class Deposit {
  Deposit._();

  static const String _fontFamily = 'deposit';

  static const IconData deposit_outlined = IconData(0xe900, fontFamily: _fontFamily);
}

import 'package:flutter/material.dart';

import 'app_dimens.dart';

class AppShapes {
  static final BorderRadius roundedMedium = BorderRadius.circular(AppDimens.r12);

  static final ShapeBorder cardShape = RoundedRectangleBorder(borderRadius: roundedMedium);

  static final ShapeBorder dialogShape = RoundedRectangleBorder(borderRadius: roundedMedium);
}

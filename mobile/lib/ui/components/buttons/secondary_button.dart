import 'dart:ui';

import 'package:bittrex_app/ui/theme/theme.dart';
import 'package:flutter/material.dart';

class SecondaryButton extends OutlineButton {
  SecondaryButton({
    Key key,
    @required VoidCallback onPressed,
    Widget child,
    Color textColor = AppColors.turquoise,
    Color borderColor = AppColors.silver,
    Color disabledTextColor = AppColors.disabledTurquoise,
    EdgeInsets padding,
  }) : super(
          key: key,
          borderSide: BorderSide(
            color: borderColor,
            width: 1.0,
          ),
          onPressed: onPressed,
          child: child,
          shape: const RoundedRectangleBorder(
            side: BorderSide.none,
            borderRadius: const BorderRadius.all(Radius.circular(6.0)),
          ),
          disabledTextColor: disabledTextColor,
          highlightedBorderColor: AppColors.silver,
          textColor: textColor,
          padding: padding,
        );
}

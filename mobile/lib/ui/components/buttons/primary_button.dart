import 'package:bittrex_app/ui/theme/theme.dart';
import 'package:flutter/material.dart';

import './button_size.dart';

class PrimaryButton extends RaisedButton {
  PrimaryButton({
    Key key,
    @required VoidCallback onPressed,
    ButtonSize size = ButtonSize.normal,
    Widget child,
    elevation = 1.0,
    cornerRadius = 6.0,
    bool showTopCornerRadius = true,
    bool showBottomCornerRadius = true,
    Color color = AppColors.turquoise,
    Color disabledColor = AppColors.disabledTurquoise,
  }) : super(
          key: key,
          onPressed: onPressed,
          child: child,
          shape: RoundedRectangleBorder(
            side: BorderSide.none,
            borderRadius: BorderRadius.vertical(
              top: showTopCornerRadius
                  ? Radius.circular(cornerRadius)
                  : Radius.zero,
              bottom: showBottomCornerRadius
                  ? Radius.circular(cornerRadius)
                  : Radius.zero,
            ),
          ),
          elevation: elevation,
          disabledElevation: 1.0,
          highlightElevation: 1.0,
          disabledTextColor: Colors.white,
          textColor: Colors.white,
          disabledColor: disabledColor,
          color: color,
        );
}

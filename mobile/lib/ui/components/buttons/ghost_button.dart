import 'package:bittrex_app/ui/components/buttons/button_size.dart';
import 'package:bittrex_app/ui/theme/theme.dart';
import 'package:flutter/material.dart';

class GhostButton extends FlatButton {
  const GhostButton({
    Key key,
    @required VoidCallback onPressed,
    ButtonSize size = ButtonSize.normal,
    Widget child,
    EdgeInsets padding,
    Color color = AppColors.turquoise,
  }) : super(
          key: key,
          onPressed: onPressed,
          padding: padding,
          child: child,
          textColor: color,
        );
}

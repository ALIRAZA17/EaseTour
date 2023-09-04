import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

extension ExAppBarDefault on AppBar {
  static const kAppToolbarHeight = 80.0;
  static defaultBar(
    BuildContext context, {
    IconData? leadingIcon,
    Widget? leadingWidget,
    VoidCallback? onLeadingTap,
    bool centerTitle = false,
    String? titleText,
    Widget? titleWidget,
    List<Widget>? actions,
    double? leadingWidth,
  }) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      leading: () {
        if (leadingWidget != null) {
          return leadingWidget;
        }
        if (leadingIcon != null || onLeadingTap != null) {
          return IconButton(
            onPressed: onLeadingTap,
            iconSize: 24,
            icon: Icon(leadingIcon ?? Icons.arrow_back),
          );
        }
        return null;
      }.call(),
      leadingWidth: leadingWidth,
      centerTitle: centerTitle,
      title: () {
        if (titleWidget != null) {
          return titleWidget;
        }
        if (titleText != null) {
          return Text(
            titleText,
            style: const TextStyle(fontSize: 16),
          );
        }
        return null;
      }.call(),
      actions: actions,
      toolbarHeight: kAppToolbarHeight,
    );
  }
}

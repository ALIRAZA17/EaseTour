import 'package:ease_tour/common/resources/app_theme/theme_provider.dart';
import 'package:ease_tour/common/resources/constants/padding.dart';
import 'package:ease_tour/common/resources/constants/styles.dart';
import 'package:ease_tour/common/widgets/button/action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:provider/provider.dart';

//ignore: must_be_immutable
class EtAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String? title;
  final bool addBackButton;
  final bool addLeadingButton;
  final Widget? leadingMenu;
  final List<Widget>? actions;
  final VoidCallback? onBackPress;
  final VoidCallback? onLeadingPress;
  final bool search;
  final Color? color;
  final Widget? searchWidget;
  final bool showWelcome;
  const EtAppBar({
    super.key,
    this.title,
    this.actions,
    this.onBackPress,
    this.onLeadingPress,
    this.showWelcome = false,
    this.leadingMenu,
    this.addLeadingButton = false,
    this.addBackButton = true,
    this.search = false,
    this.searchWidget,
    this.color,
  });

  @override
  State<EtAppBar> createState() => _EtAppBarState();

  @override
  Size get preferredSize => const Size(64, 64);
}

class _EtAppBarState extends State<EtAppBar> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ThemeProvider value, child) => SafeArea(
        child: widget.search
            ? Padding(
                padding: Pads.primaryPadding,
                child: widget.searchWidget ?? const SizedBox(),
              )
            : Container(
                color: widget.color,
                padding: Pads.primaryPadding,
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    widget.addLeadingButton
                        ? Positioned(
                            top: 10,
                            left: 0,
                            child: ActionButton(
                              icon: 'assets/icons/bars-ver.svg',
                              iconColor: Styles.primaryIconColor,
                              onTap: widget.onLeadingPress ?? () {},
                            ))
                        : widget.addBackButton
                            ? Positioned(
                                top: 10,
                                left: 0,
                                child: GestureDetector(
                                  onTap: widget.onBackPress ??
                                      () => Navigator.pop(context),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                          'assets/icons/angle-left.svg'),
                                      Text(
                                        'Back',
                                        style: Styles.displayMedLightStyle,
                                      )
                                    ],
                                  ),
                                ))
                            : const SizedBox(),
                    widget.showWelcome
                        ? Positioned(
                            top: 0,
                            left: 0,
                            child: Expanded(
                              child: RichText(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(
                                  text: 'Welcome ',
                                  style: Styles.displayLargeNormalStyle,
                                  children: [
                                    TextSpan(
                                      text: widget.title,
                                      style: Styles.displayLargeNormalStyle,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        : widget.title != null
                            ? Center(
                                child: Text(widget.title!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Styles.displayLargeNormalStyle),
                              )
                            : const Center(child: SizedBox()),
                    Positioned(
                        right: 0,
                        top: 10,
                        child:
                            Row(children: widget.actions ?? [const SizedBox()]))
                  ],
                ),
              ),
      ),
    );
  }
}

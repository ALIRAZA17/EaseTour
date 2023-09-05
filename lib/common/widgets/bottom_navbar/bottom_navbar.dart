import 'package:ease_tour/common/resources/constants/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/svg.dart';

class BottomNavigation extends StatelessWidget {
  final int currentIndex;
  // final List<Widget> widgets;
  final List<String> icons;
  final List<String> labels;
  final void Function(int)? itemChanged;
  const BottomNavigation({
    super.key,
    this.currentIndex = 0,
    required this.icons,
    required this.labels,
    this.itemChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 62,
      child: PlatformNavBar(
        material: (context, platform) {
          return MaterialNavBarData(
            selectedItemColor: Styles.primaryColor,
            unselectedItemColor: Styles.primaryTextColor,
            type: BottomNavigationBarType.fixed,
          );
        },
        cupertino: (context, platform) {
          return CupertinoTabBarData();
        },
        currentIndex: currentIndex,
        itemChanged: itemChanged,
        backgroundColor: Styles.backgroundColor,
        // items: items.map((item) => BottomNavigationBarItem(icon: SvgPicture.asset(item.icon),label: item.label)).toList(),
        items: [
          for (int item = 0; item < icons.length; item++) ...{
            BottomNavigationBarItem(
              icon:
                  SvgPicture.asset(icons[item], color: Styles.primaryTextColor),
              label: labels[item],
              activeIcon:
                  SvgPicture.asset(icons[item], color: Styles.primaryColor),
            )
          }
        ],
      ),
    );
  }
}

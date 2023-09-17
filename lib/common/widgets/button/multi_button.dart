import 'package:ease_tour/common/resources/constants/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MultiButton extends StatelessWidget {
  final VoidCallback? onTap;
  final bool disabled;
  final String btnLabel;
  final bool expanded;
  final Color? color;
  final Color? labelColor;
  final double verticalPad;
  final bool addIcon;
  const MultiButton(
      {Key? key,
      this.onTap,
      required this.btnLabel,
      this.color,
      this.disabled = false,
      this.expanded = false,
      this.addIcon = false,
      required this.verticalPad,
      this.labelColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: Container(
        width: !expanded ? MediaQuery.of(context).size.width * 0.5 : null,
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: verticalPad),
        // height: 48,
        decoration: BoxDecoration(
          color: color ??
              (disabled ? Styles.secondryTextColor : Styles.buttonColorPrimary),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                btnLabel,
                style: Styles.displayMedBoldStyle.copyWith(
                    color: labelColor ?? Styles.primaryButtonTextColor),
                // textAlign: TextAlign.center,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: SvgPicture.asset('assets/icons/for_arrow.svg'),
            ),
          ],
        ),
      ),
    );
  }
}

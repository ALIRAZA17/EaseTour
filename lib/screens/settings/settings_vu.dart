import 'package:ease_tour/common/resources/app_theme/theme_provider.dart';
import 'package:ease_tour/common/resources/constants/styles.dart';
import 'package:ease_tour/common/widgets/appBar/app_bar.dart';
import 'package:ease_tour/screens/settings/settings_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as pv;
import 'package:stacked/stacked.dart';

class SettingsView extends StackedView<SettingsViewModel> {
  const SettingsView({super.key});

  @override
  Widget builder(
      BuildContext context, SettingsViewModel viewModel, Widget? child) {
    return pv.Consumer(
      builder: (builder, ThemeProvider provider, child) {
        return Scaffold(
          backgroundColor: Styles.backgroundColor,
          appBar: EtAppBar(
            height: 90,
            title: 'Settings',
            addBackButton: true,
            onBackPress: viewModel.onBackPressed,
          ),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                baseContainer('Change Password', viewModel.onChnagePassword),
                baseContainer('Change Language', viewModel.onChnageLanguge),
                baseContainer('Private Policy', viewModel.onPrivacyPolicy),
                baseContainer('Contact Us', viewModel.onContactUs),
                baseContainer('Delete Account', viewModel.onDeleteAcc),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  SettingsViewModel viewModelBuilder(BuildContext context) {
    return SettingsViewModel();
  }
}

Widget baseContainer(String title, void Function()? onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
          color: Styles.backgroundColor,
          border: Border.all(color: Styles.primaryColor),
          borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Styles.displayMedNormalStyle
                .copyWith(color: Styles.primaryTextColor),
          ),
          const Icon(Icons.arrow_forward_ios_rounded)
        ],
      ),
    ),
  );
}

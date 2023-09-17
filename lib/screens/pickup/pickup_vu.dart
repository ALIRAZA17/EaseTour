import 'package:ease_tour/common/resources/app_theme/theme_provider.dart';
import 'package:ease_tour/common/resources/constants/styles.dart';
import 'package:ease_tour/common/widgets/appBar/app_bar.dart';
import 'package:ease_tour/screens/pickup/pickup_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

class PickupView extends StackedView<PickupViewModel> {
  const PickupView({super.key});

  @override
  Widget builder(
      BuildContext context, PickupViewModel viewModel, Widget? child) {
    return Consumer(builder: (context, ThemeProvider provider, child) {
      return Scaffold(
        appBar: EtAppBar(
          height: 90,
          addBackButton: true,
          onBackPress: viewModel.onBackPressed,
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(
                  top: 25, bottom: 40, left: 15, right: 15),
              color: Styles.primaryColor,
              child: Column(
                children: [
                  Text(
                    'Invite Friends',
                    style: Styles.displayXlBoldStyle
                        .copyWith(color: Styles.primaryTextColor),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  TextFormField(
                    enabled: true,
                    autofocus: false,
                    maxLines: 1,
                    controller: viewModel.textEditingController,
                    enableSuggestions: true,
                    style: Styles.displayMedNormalStyle,
                    decoration: InputDecoration(
                      fillColor: Styles.textFormFieldBackColor,
                      filled: true,
                      prefixIcon: Icon(
                        Icons.search,
                        color: Styles.primaryButtonTextColor,
                      ),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                          borderSide: BorderSide.none),
                      isCollapsed: true,
                      label: Text(
                        'Search',
                        style: Styles.displaySmNormalStyle
                            .copyWith(color: Styles.primaryButtonTextColor),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                  ),
                ],
              ),
            ),
            friendsList(),
          ],
        ),
      );
    });
  }

  @override
  PickupViewModel viewModelBuilder(BuildContext context) {
    return PickupViewModel();
  }
}

Widget friendsList() {
  return Expanded(
    child: SingleChildScrollView(
      child: Column(
        children: [
          ListView.builder(
            padding: const EdgeInsets.only(top: 20),
            itemCount: 5,
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(
                  top: 20.0,
                  left: 15,
                ),
                child: Row(
                  children: [
                    ClipOval(
                      child: Container(
                        width: 50,
                        height: 50,
                        color: Styles.primaryColor,
                      ),
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(
                          bottom: 20,
                          right: 15,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom:
                                BorderSide(color: Styles.borderColor, width: 3),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Jhonny Rias',
                              style: Styles.displayXMxtrLightStyle,
                            ),
                            Container(
                              width: 46.11199951171875,
                              height: 31.154996871948242,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Styles.checkContainerColor),
                              child: Image.asset('assets/icons/tick2.png'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    ),
  );
}

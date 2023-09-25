import 'package:ease_tour/common/resources/app_theme/theme_provider.dart';
import 'package:ease_tour/common/resources/constants/styles.dart';
import 'package:ease_tour/common/widgets/appBar/app_bar.dart';
import 'package:ease_tour/screens/history/history_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as pv;
import 'package:stacked/stacked.dart';

class HistroyView extends StackedView<HistoryViewModel> {
  const HistroyView({super.key});

  @override
  Widget builder(
      BuildContext context, HistoryViewModel viewModel, Widget? child) {
    return pv.Consumer(
      builder: (builder, ThemeProvider provider, child) {
        return Scaffold(
            backgroundColor: Styles.backgroundColor,
            appBar: EtAppBar(
              height: 90,
              title: 'History',
              addBackButton: true,
              onBackPress: viewModel.onBackPressed,
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  height: 125,
                  decoration: BoxDecoration(
                    color: Styles.primaryColor,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Completed Rides',
                    style: Styles.displayXlBoldStyle
                        .copyWith(color: Styles.primaryTextColor),
                  ),
                ),
                historyList(),
              ],
            ));
      },
    );
  }

  Expanded historyList() {
    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(top: 20),
              shrinkWrap: true,
              itemCount: 15,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                      color: Styles.backgroundColor,
                      border: Border.all(color: Styles.primaryColor),
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nate Diaz',
                            style: Styles.displaySmBoldStyle
                                .copyWith(color: Styles.primaryTextColor),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            'Mustang Shelby Gt',
                            style: Styles.displayXSNormalStyle
                                .copyWith(color: Styles.secondryTextColor),
                          )
                        ],
                      ),
                      Text(
                        'Today at 09:20 am',
                        style: Styles.displayXSNormalStyle
                            .copyWith(color: Styles.primaryTextColor),
                      ),
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  HistoryViewModel viewModelBuilder(BuildContext context) {
    return HistoryViewModel();
  }
}

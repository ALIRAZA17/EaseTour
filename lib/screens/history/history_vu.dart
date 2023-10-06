import 'package:ease_tour/common/resources/app_theme/theme_provider.dart';
import 'package:ease_tour/common/resources/constants/styles.dart';
import 'package:ease_tour/common/widgets/appBar/app_bar.dart';
import 'package:ease_tour/screens/history/history_vm.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
            title: 'Setting',
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
              historyList(viewModel),
            ],
          ),
        );
      },
    );
  }

  Widget historyList(HistoryViewModel viewModel) {
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
              itemCount: viewModel.historyData.length,
              itemBuilder: (context, index) {
                final historyItem =
                    viewModel.historyData.values.elementAt(index);

                return FutureBuilder<Map<String, dynamic>>(
                  future: viewModel.fetchDriverInfo(historyItem['driver_id']),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      final driverInfo = snapshot.data;

                      return Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Styles.backgroundColor,
                          border: Border.all(color: Styles.primaryColor),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${driverInfo?['full_name']}",
                                  style: Styles.displaySmBoldStyle.copyWith(
                                    color: Styles.primaryTextColor,
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  '${driverInfo?['vehicleName']}',
                                  style: Styles.displayXSNormalStyle.copyWith(
                                    color: Styles.secondryTextColor,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const Text('No data available');
                    }
                  },
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
    HistoryViewModel historyViewModel = HistoryViewModel();
    historyViewModel.history(FirebaseAuth.instance.currentUser!.uid);
    return historyViewModel;
  }
}

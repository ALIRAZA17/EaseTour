import 'package:ease_tour/screens/bottom_nav/offers/offers_vm.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class OffersView extends StackedView<OffersViewModel> {
  const OffersView({super.key});

  @override
  Widget builder(
      BuildContext context, OffersViewModel viewModel, Widget? child) {
    return const Placeholder();
  }

  @override
  OffersViewModel viewModelBuilder(BuildContext context) {
    return OffersViewModel();
  }
}

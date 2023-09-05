import 'package:ease_tour/screens/bottom_nav/favorites/favorites_vm.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class FavoritesView extends StackedView<FavoritesViewModel> {
  const FavoritesView({super.key});

  @override
  Widget builder(
      BuildContext context, FavoritesViewModel viewModel, Widget? child) {
    return const Placeholder();
  }

  @override
  FavoritesViewModel viewModelBuilder(BuildContext context) {
    return FavoritesViewModel();
  }
}

import 'package:ease_tour/screens/bottom_nav/profile/profile_vm.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ProfileView extends StackedView<ProfileViewModel> {
  const ProfileView({super.key});

  @override
  Widget builder(
      BuildContext context, ProfileViewModel viewModel, Widget? child) {
    return const Placeholder();
  }

  @override
  ProfileViewModel viewModelBuilder(BuildContext context) {
    return ProfileViewModel();
  }
}

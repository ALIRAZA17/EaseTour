import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final contactTextControllerProvider =
    Provider.autoDispose<TextEditingController>((ref) {
  final controller = TextEditingController();
  ref.onDispose(() {
    controller.dispose();
  });
  return controller;
});

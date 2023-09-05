import 'package:ease_tour/common/resources/app_theme/theme_provider.dart';
import 'package:ease_tour/common/resources/constants/routes.dart';
import 'package:ease_tour/common/resources/constants/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      builder: (_, __) => Consumer(
        builder: (context, ThemeProvider provider, child) => GetMaterialApp(
          title: 'Ease Tour',
          theme: Themes.lightThemeData(),
          darkTheme: Themes.darkThemeData(),
          themeMode: provider.themeMode,
          debugShowCheckedModeBanner: false,
          initialRoute: '/onBoarding/primary',
          getPages: appRoutes(),
        ),
      ),
    );
  }
}

import 'package:ease_tour/common/resources/app_theme/theme_provider.dart';
import 'package:ease_tour/common/resources/constants/routes.dart';
import 'package:ease_tour/common/resources/constants/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart' as provider;

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return provider.ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      builder: (_, __) => Consumer(
        builder: (context, WidgetRef ref, child) {
          final themeProvider = ref.read(ThemeProvider.provider);
          return GetMaterialApp(
            title: 'Ease Tour',
            theme: Themes.lightThemeData(),
            darkTheme: Themes.darkThemeData(),
            themeMode: themeProvider.themeMode,
            debugShowCheckedModeBanner: false,
            initialRoute: '/driver_main_screen',
            getPages: appRoutes(),
          );
        },
      ),
    );
  }
}

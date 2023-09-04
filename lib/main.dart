import 'package:ease_tour/resources/constants/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'resources/app_theme/theme_provider.dart';
import 'resources/constants/routes.dart';

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
    // return MaterialApp(
    //   title: 'Flutter Demo',
    //   debugShowCheckedModeBanner: false,
    //   theme: ThemeData(
    //     colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    //     useMaterial3: true,
    //   ),
    //   home: const PrimaryView(),
    // );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(widget.title),
//       ),
//       body: const Center(
//         child: Text("Welcome"),
//       ),
//     );
//   }
// }

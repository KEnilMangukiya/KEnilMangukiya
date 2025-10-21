import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'src/core/routes/app_pages.dart';
import 'src/core/routes/app_routes.dart';
import 'src/core/theme/app_theme.dart';
import 'src/di/injector.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const BetXApp());
}

class BetXApp extends StatelessWidget {
  const BetXApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'BetX',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
      defaultTransition: Transition.cupertino,
      routingCallback: (routing) {
        // hook for analytics if needed
      },
    );
  }
}


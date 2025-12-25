import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'views/create_call_info_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Call Info App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const CreateCallInfoView(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'src/screens/home_screen.dart';
import 'src/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set system UI style for iPhone
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.surface,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const FiscusTapApp());
}

class FiscusTapApp extends StatelessWidget {
  const FiscusTapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fiscus Tap',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const HomeScreen(),
    );
  }
}

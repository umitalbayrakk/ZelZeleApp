import 'package:earthquake_flutter_app/views/splash_views.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EarthquakeFlutterApp',
      theme: ThemeData(),
      home: OnboardingView(),
    );
  }
}

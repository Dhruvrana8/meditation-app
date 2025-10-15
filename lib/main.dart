import 'package:flutter/material.dart';
import 'package:meditation/models/session_controller.dart';
import 'package:meditation/screens/breathing_screen.dart';
import 'package:meditation/screens/home_screen.dart';
import 'package:meditation/screens/music_screen.dart';
import 'package:meditation/screens/timer_screen.dart';
import 'package:meditation/theme.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SessionController(),
      child: MaterialApp(
        title: 'Meditation',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        routes: {
          '/': (_) => const HomeScreen(),
          '/timer': (_) => const TimerScreen(),
          '/breathing': (_) => const BreathingScreen(),
          '/music': (_) => const MusicScreen(),
        },
      ),
    );
  }
}

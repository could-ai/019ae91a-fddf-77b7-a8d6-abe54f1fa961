import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const FitnessApp());
}

class FitnessApp extends StatelessWidget {
  const FitnessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Домашен Фитнес',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.tealAccent,
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: ColorScheme.dark(
          primary: Colors.tealAccent,
          secondary: Colors.orangeAccent,
          surface: const Color(0xFF1E1E1E),
        ),
        useMaterial3: true,
        fontFamily: 'Roboto', // Default flutter font is usually fine, but specifying is good practice
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
      },
    );
  }
}

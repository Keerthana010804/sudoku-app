import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_app/features/splash/splash_screen.dart';
import 'package:sudoku_app/features/sudoku/view/sudoku_screen.dart';
import 'package:sudoku_app/features/sudoku/viewmodel/sudoku_viewmodel.dart';

void main() {
  runApp(const MyApp());
}

// Root Widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SudokuViewModel(),
        ),
      ],
      child: const AppView(),
    );
  }
}

// Main App UI
class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sudoku App',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue
        ),
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const SplashScreen(),
        '/game': (_) => const SudokuScreen(),
      },
    );
  }
}


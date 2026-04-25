import 'package:flutter/material.dart';
import 'package:sudoku_app/features/home/widgets/home_app_bar.dart';
import 'package:sudoku_app/features/home/widgets/home_body.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(),
      body: HomeBody(),
    );
  }
}
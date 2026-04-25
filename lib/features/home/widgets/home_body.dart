import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_app/features/home/widgets/daily_challenge_card.dart';
import 'package:sudoku_app/features/home/widgets/primary_button.dart';
import 'package:sudoku_app/features/home/widgets/resume_card.dart';
import 'package:sudoku_app/features/home/widgets/title_section.dart';
import 'package:sudoku_app/features/splash/widgets/background_pattern.dart';
import 'package:sudoku_app/features/sudoku/viewmodel/sudoku_viewmodel.dart';
import 'package:sudoku_app/features/sudoku/widgets/difficulty_bottom_sheet.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SudokuViewModel>();

    return Stack(
      children: [
        const BackgroundPattern(),
        Padding(
          padding: const EdgeInsets.all(20),
          child: FutureBuilder<bool>(
            future: vm.hasSavedGame(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }

              final hasGame = snapshot.data!;

              return Center(
                child: Column(
                  children: [
                    const DailyChallengeCard(),
                    const SizedBox(height: 30),
                    const TitleSection(),
                    const SizedBox(height: 30),

                    if (hasGame) ...[
                      ResumeCard(
                        difficulty: vm.difficultyText,
                        time: vm.formattedTime,
                        onTap: () async {
                          await vm.loadGame();
                          Navigator.pushNamed(context, '/game');
                        },
                      ),
                      const SizedBox(height: 30),
                    ],

                    PrimaryButton(
                      text: "New Game",
                      onPressed: () {
                        showDifficultyBottomSheet(context);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
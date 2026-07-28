import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../logic/game_cubit.dart';

class ScoreBoardWidget extends StatelessWidget {
  final GameState state;

  const ScoreBoardWidget({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF191A24),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildScoreCard(state.playerXName, state.scoreX, const Color(0xFFFF2A6D), state.isXTurn && state.status == GameStateStatus.playing),
          Container(height: 40, width: 1, color: Colors.white12),
          _buildScoreCard('DRAWS', state.draws, Colors.grey, false),
          Container(height: 40, width: 1, color: Colors.white12),
          _buildScoreCard(state.playerOName, state.scoreO, const Color(0xFF05D9E8), !state.isXTurn && state.status == GameStateStatus.playing),
        ],
      ),
    );
  }

  Widget _buildScoreCard(String title, int score, Color color, bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? color.withOpacity(0.15) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isActive ? color : Colors.transparent),
      ),
      child: Column(
        children: [
          Text(title, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('$score', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class GameBoardWidget extends StatelessWidget {
  final GameCubit cubit;
  final GameState state;

  const GameBoardWidget({
    super.key,
    required this.cubit,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF191A24),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 25,
            spreadRadius: 5,
          ),
        ],
      ),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 9,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          bool isWinningCell = state.winningLine?.contains(index) ?? false;
          String val = state.board[index];

          return GestureDetector(
            onTap: () => cubit.makeMove(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              decoration: BoxDecoration(
                color: isWinningCell
                    ? (val == 'X' ? const Color(0xFFFF2A6D) : const Color(0xFF05D9E8)).withOpacity(0.3)
                    : const Color(0xFF0F1018),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isWinningCell
                      ? (val == 'X' ? const Color(0xFFFF2A6D) : const Color(0xFF05D9E8))
                      : Colors.white.withOpacity(0.05),
                  width: isWinningCell ? 2.5 : 1,
                ),
              ),
              child: Center(
                child: AnimatedScale(
                  scale: val.isEmpty ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    val,
                    style: TextStyle(
                      fontSize: 44,
                      fontWeight: FontWeight.bold,
                      color: val == 'X' ? const Color(0xFFFF2A6D) : const Color(0xFF05D9E8),
                      shadows: [
                        Shadow(
                          color: val == 'X' ? const Color(0xFFFF2A6D) : const Color(0xFF05D9E8),
                          blurRadius: 15,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ControlsWidget extends StatelessWidget {
  final GameCubit cubit;
  final GameState state;

  const ControlsWidget({
    super.key,
    required this.cubit,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SegmentedButton<GameMode>(
          segments: const [
            ButtonSegment(value: GameMode.vsAi, label: Text('VS AI')),
            ButtonSegment(value: GameMode.pvp, label: Text('PVP PASS')),
          ],
          selected: {state.gameMode},
          onSelectionChanged: (Set<GameMode> selected) {
            cubit.setGameMode(selected.first);
          },
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return const Color(0xFFFF2A6D);
              }
              return const Color(0xFF191A24);
            }),
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: () => cubit.resetBoard(),
          icon: const Icon(Icons.play_arrow_rounded),
          label: const Text('NEXT ROUND', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF05D9E8),
            foregroundColor: Colors.black,
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
      ],
    );
  }
}

class HeaderWidget extends StatelessWidget {
  final GameCubit cubit;
  final GameState state;

  const HeaderWidget({
    super.key,
    required this.cubit,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF2A6D), Color(0xFF05D9E8)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF2A6D).withOpacity(0.4),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Center(
                child: Text('XO', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
              ),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('MR X', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 1.5)),
                Text('GAMEHUB', style: TextStyle(color: Colors.grey, fontSize: 10, letterSpacing: 2)),
              ],
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.edit_note, color: Color(0xFF05D9E8)),
              onPressed: () => _showNameInputDialog(context, cubit, state),
            ),
            IconButton(
              icon: const Icon(Icons.refresh_rounded, color: Color(0xFFFF2A6D)),
              onPressed: () => cubit.resetAll(),
            ),
          ],
        ),
      ],
    );
  }

  void _showNameInputDialog(BuildContext context, GameCubit cubit, GameState state) {
    final xController = TextEditingController(text: state.playerXName);
    final oController = TextEditingController(text: state.playerOName);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF191A24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('CUSTOMIZE NAMES', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: xController,
                decoration: const InputDecoration(
                  labelText: 'Player X Name',
                  labelStyle: TextStyle(color: Color(0xFFFF2A6D)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: oController,
                enabled: state.gameMode == GameMode.pvp,
                decoration: InputDecoration(
                  labelText: state.gameMode == GameMode.vsAi ? 'AI Name (Fixed)' : 'Player O Name',
                  labelStyle: const TextStyle(color: Color(0xFF05D9E8)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CANCEL'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF2A6D)),
              onPressed: () {
                cubit.updatePlayerNames(xController.text, oController.text);
                Navigator.pop(context);
              },
              child: const Text('SAVE'),
            ),
          ],
        );
      },
    );
  }
}

class BrandingWidget extends StatelessWidget {
  const BrandingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: const Text(
        'DESIGNED π FADY',
        style: TextStyle(
          color: Colors.grey,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../logic/game_cubit.dart';
import '../widgets/game_provider.dart';
import '../widgets/game_widgets.dart';
import '../painters/particle_effect_painter.dart';

class MainGameScreen extends StatefulWidget {
  const MainGameScreen({super.key});

  @override
  State<MainGameScreen> createState() => _MainGameScreenState();
}

class _MainGameScreenState extends State<MainGameScreen> with SingleTickerProviderStateMixin {
  late AnimationController _effectController;

  @override
  void initState() {
    super.initState();
    _effectController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
  }

  @override
  void dispose() {
    _effectController.dispose();
    super.dispose();
  }

  void _triggerEndGameEffect(GameStateStatus status) {
    if (status == GameStateStatus.won || status == GameStateStatus.lost || status == GameStateStatus.draw) {
      _effectController.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = GameProvider.of(context);

    return ValueListenableBuilder<GameState>(
      valueListenable: cubit,
      builder: (context, state, child) {
        _triggerEndGameEffect(state.status);

        return Scaffold(
          body: Stack(
            children: [
              SafeArea(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth > 850) {
                      return _buildWideLayout(context, cubit, state, constraints);
                    } else {
                      return _buildMobileLayout(context, cubit, state, constraints);
                    }
                  },
                ),
              ),
              if (state.status == GameStateStatus.won || state.status == GameStateStatus.lost)
                Positioned.fill(
                  child: IgnorePointer(
                    child: CustomPaint(
                      painter: ParticleEffectPainter(
                        progress: _effectController,
                        isWin: state.status == GameStateStatus.won,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWideLayout(BuildContext context, GameCubit cubit, GameState state, BoxConstraints constraints) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HeaderWidget(cubit: cubit, state: state),
                ScoreBoardWidget(state: state),
                ControlsWidget(cubit: cubit, state: state),
                const BrandingWidget(),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Center(
            child: Container(
              width: 500,
              height: 500,
              padding: const EdgeInsets.all(24.0),
              child: GameBoardWidget(cubit: cubit, state: state),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context, GameCubit cubit, GameState state, BoxConstraints constraints) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          HeaderWidget(cubit: cubit, state: state),
          ScoreBoardWidget(state: state),
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 420, maxHeight: 420),
                  child: GameBoardWidget(cubit: cubit, state: state),
                ),
              ),
            ),
          ),
          ControlsWidget(cubit: cubit, state: state),
          const SizedBox(height: 8),
          const BrandingWidget(),
        ],
      ),
    );
  }
}


import 'package:flutter/material.dart';
import '../logic/game_cubit.dart';

class GameProvider extends InheritedWidget {
  final GameCubit cubit;

  GameProvider({
    super.key,
    required super.child,
  }) : cubit = GameCubit();

  static GameCubit of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<GameProvider>()!.cubit;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}


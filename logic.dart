import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/game_state.dart';

class GameCubit extends ValueNotifier<GameState> {
  GameCubit() : super(GameState.initial());

  void setGameMode(GameMode mode) {
    String oName = mode == GameMode.vsAi ? 'AI Bot' : 'Player O';
    value = GameState.initial().copyWith(
      gameMode: mode,
      playerXName: value.playerXName,
      playerOName: oName,
      scoreX: value.scoreX,
      scoreO: value.scoreO,
      draws: value.draws,
    );
  }

  void updatePlayerNames(String xName, String oName) {
    value = value.copyWith(
      playerXName: xName.isEmpty ? 'Player X' : xName,
      playerOName: oName.isEmpty ? (value.gameMode == GameMode.vsAi ? 'AI Bot' : 'Player O') : oName,
    );
  }

  void makeMove(int index) {
    if (value.board[index] != '' || value.status == GameStateStatus.won || value.status == GameStateStatus.lost || value.status == GameStateStatus.draw) {
      return;
    }

    final newBoard = List<String>.from(value.board);
    newBoard[index] = value.isXTurn ? 'X' : 'O';

    value = value.copyWith(
      board: newBoard,
      status: GameStateStatus.playing,
    );

    _evaluateGame(newBoard);

    if (value.status == GameStateStatus.playing) {
      bool nextTurn = !value.isXTurn;
      value = value.copyWith(isXTurn: nextTurn);

      if (value.gameMode == GameMode.vsAi && !nextTurn) {
        Timer(const Duration(milliseconds: 400), _makeAiMove);
      }
    }
  }

  void _makeAiMove() {
    int bestMove = _getBestMove(value.board);
    if (bestMove != -1) {
      makeMove(bestMove);
    }
  }

  int _getBestMove(List<String> currentBoard) {
    int bestScore = -1000;
    int move = -1;
    for (int i = 0; i < 9; i++) {
      if (currentBoard[i] == '') {
        currentBoard[i] = 'O';
        int score = _minimax(currentBoard, 0, false);
        currentBoard[i] = '';
        if (score > bestScore) {
          bestScore = score;
          move = i;
        }
      }
    }
    return move;
  }

  int _minimax(List<String> board, int depth, bool isMaximizing) {
    String? winner = _checkWinnerStatic(board);
    if (winner == 'O') return 10 - depth;
    if (winner == 'X') return depth - 10;
    if (!board.contains('')) return 0;

    if (isMaximizing) {
      int bestScore = -1000;
      for (int i = 0; i < 9; i++) {
        if (board[i] == '') {
          board[i] = 'O';
          int score = _minimax(board, depth + 1, false);
          board[i] = '';
          bestScore = max(score, bestScore);
        }
      }
      return bestScore;
    } else {
      int bestScore = 1000;
      for (int i = 0; i < 9; i++) {
        if (board[i] == '') {
          board[i] = 'X';
          int score = _minimax(board, depth + 1, true);
          board[i] = '';
          bestScore = min(score, bestScore);
        }
      }
      return bestScore;
    }
  }

  String? _checkWinnerStatic(List<String> b) {
    const lines = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8],
      [0, 3, 6], [1, 4, 7], [2, 5, 8],
      [0, 4, 8], [2, 4, 6]
    ];
    for (var line in lines) {
      if (b[line[0]] != '' && b[line[0]] == b[line[1]] && b[line[0]] == b[line[2]]) {
        return b[line[0]];
      }
    }
    return null;
  }

  void _evaluateGame(List<String> b) {
    const lines = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8],
      [0, 3, 6], [1, 4, 7], [2, 5, 8],
      [0, 4, 8], [2, 4, 6]
    ];

    for (var line in lines) {
      if (b[line[0]] != '' && b[line[0]] == b[line[1]] && b[line[0]] == b[line[2]]) {
        bool isXWinner = b[line[0]] == 'X';
        GameStateStatus endStatus;
        if (value.gameMode == GameMode.vsAi) {
          endStatus = isXWinner ? GameStateStatus.won : GameStateStatus.lost;
        } else {
          endStatus = GameStateStatus.won;
        }

        value = value.copyWith(
          status: endStatus,
          winningLine: line,
          scoreX: isXWinner ? value.scoreX + 1 : value.scoreX,
          scoreO: !isXWinner ? value.scoreO + 1 : value.scoreO,
        );
        return;
      }
    }

    if (!b.contains('')) {
      value = value.copyWith(
        status: GameStateStatus.draw,
        draws: value.draws + 1,
      );
    }
  }

  void resetBoard() {
    value = value.copyWith(
      board: ['', '', '', '', '', '', '', '', ''],
      isXTurn: true,
      status: GameStateStatus.initial,
      winningLine: null,
    );
  }

  void resetAll() {
    value = GameState.initial();
  }
}



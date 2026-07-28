enum GameMode { pvp, vsAi }
enum GameStateStatus { initial, playing, won, lost, draw }

class GameState {
  final List<String> board;
  final bool isXTurn;
  final GameMode gameMode;
  final GameStateStatus status;
  final String playerXName;
  final String playerOName;
  final int scoreX;
  final int scoreO;
  final int draws;
  final List<int>? winningLine;

  const GameState({
    required this.board,
    required this.isXTurn,
    required this.gameMode,
    required this.status,
    required this.playerXName,
    required this.playerOName,
    required this.scoreX,
    required this.scoreO,
    required this.draws,
    this.winningLine,
  });

  factory GameState.initial() {
    return const GameState(
      board: ['', '', '', '', '', '', '', '', ''],
      isXTurn: true,
      gameMode: GameMode.vsAi,
      status: GameStateStatus.initial,
      playerXName: 'Player X',
      playerOName: 'AI Bot',
      scoreX: 0,
      scoreO: 0,
      draws: 0,
      winningLine: null,
    );
  }

  GameState copyWith({
    List<String>? board,
    bool? isXTurn,
    GameMode? gameMode,
    GameStateStatus? status,
    String? playerXName,
    String? playerOName,
    int? scoreX,
    int? scoreO,
    int? draws,
    List<int>? winningLine,
  }) {
    return GameState(
      board: board ?? this.board,
      isXTurn: isXTurn ?? this.isXTurn,
      gameMode: gameMode ?? this.gameMode,
      status: status ?? this.status,
      playerXName: playerXName ?? this.playerXName,
      playerOName: playerOName ?? this.playerOName,
      scoreX: scoreX ?? this.scoreX,
      scoreO: scoreO ?? this.scoreO,
      draws: draws ?? this.draws,
      winningLine: winningLine,
    );
  }
}



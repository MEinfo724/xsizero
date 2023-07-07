import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

class VsComputer extends StatefulWidget {
  const VsComputer({Key? key}) : super(key: key);
  @override
  State<VsComputer> createState() => _VsComputer();
}

class _VsComputer extends State<VsComputer> {
  int _difficultyLevel = 0;
  late List<List<String>> _board;
  late bool _gameOver;
  late String _winner;
  late String _cpuPiece;
  late String _playerPiece;
  late bool _isPlayerTurn;
  @override
  void initState() {
    super.initState();
  }

  void _resetGame() {
    setState(() {
      _board = List.generate(3, (_) => List.generate(3, (_) => ""));
      Random random = Random();
      int coinFlip = random.nextInt(2);
      if (coinFlip == 0) {
        _cpuPiece = "X";
        _playerPiece = "O";
        _isPlayerTurn = false;
      } else {
        _cpuPiece = "O";
        _playerPiece = "X";
        _isPlayerTurn = true;
      }
      _gameOver = false;
      _winner = "";
    });
  }

  String? _checkWin() {
    String? winner;

    // check rows
    for (int i = 0; i < 3; i++) {
      if (_board[i][0] != "" && _board[i][0] == _board[i][1] && _board[i][1] == _board[i][2]) {
        winner = _board[i][0];
        break;
      }
    }

    // check columns
    if (winner == null) {
      for (int i = 0; i < 3; i++) {
        if (_board[0][i] != "" && _board[0][i] == _board[1][i] && _board[1][i] == _board[2][i]) {
          winner = _board[0][i];
          break;
        }
      }
    }

    // check diagonals
    if (winner == null) {
      if (_board[0][0] != "" && _board[0][0] == _board[1][1] && _board[1][1] == _board[2][2]) {
        winner = _board[0][0];
      } else if (_board[0][2] != "" && _board[0][2] == _board[1][1] && _board[1][1] == _board[2][0]) {
        winner = _board[0][2];
      }
    }

    // check for tie
    if (winner == null && !_board.any((row) => row.any((cell) => cell == ""))) {
      winner = "Tie";
    }

    return winner;
  }
  void _checkWinCon(int row, int col, String gamePiece) {
    if (_board[row][0] == gamePiece &&
        _board[row][1] == gamePiece &&
        _board[row][2] == gamePiece) {
      _gameOver = true;
      if (_isPlayerTurn) {
        _winner = "Player";
      } else {
        _winner = "CPU";
      }
    }
    if (_board[0][col] == gamePiece &&
        _board[1][col] == gamePiece &&
        _board[2][col] == gamePiece) {
      _gameOver = true;
      if (_isPlayerTurn) {
        _winner = "Player";
      } else {
        _winner = "CPU";
      }
    }
    if (_board[0][0] == gamePiece &&
        _board[1][1] == gamePiece &&
        _board[2][2] == gamePiece) {
      _gameOver = true;
      if (_isPlayerTurn) {
        _winner = "Player";
      } else {
        _winner = "CPU";
      }
    }
    if (_board[0][2] == gamePiece &&
        _board[1][1] == gamePiece &&
        _board[2][0] == gamePiece) {
      _gameOver = true;
      if (_isPlayerTurn) {
        _winner = "Player";
      } else {
        _winner = "CPU";
      }
    }
    //tie condition
    if (!_gameOver) {
      if (!_board.any((row) => row.any((cell) => cell == ""))) {
        _gameOver = true;
        _winner = "It's a tie!";
      }
    }
  }

  void _cpuMove(int difficultyLevel) {
    if (difficultyLevel == 1) {
      _easyCPU();
    }
    if (difficultyLevel == 2) {
      _hardCPU();
    }

  }

  void _easyCPU() {
    Random random = Random();
    int row = random.nextInt(_board.length);
    int col = random.nextInt(_board[row].length);
    if (_board[row][col] != "") {
      // If the position is already taken, try again
      _easyCPU();
    } else {
      _board[row][col] = _cpuPiece;
    }
    _checkWinCon(row, col, _cpuPiece);
  }

  void _hardCPU() {
    int bestScore = -1000;
    int bestRow = -1;
    int bestCol = -1;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (_board[i][j] == "") {
          _board[i][j] = _cpuPiece;
          int score = _minimax(0, false, -1000, 1000);
          _board[i][j] = "";

          if (score > bestScore) {
            bestScore = score;
            bestRow = i;
            bestCol = j;
          }
        }
      }
    }

    _board[bestRow][bestCol] = _cpuPiece;
    _checkWinCon(bestRow, bestCol, _cpuPiece);
  }
  int _minimax(int depth, bool isMaximizing, int alpha, int beta) {
    if (_checkWin() != null) {
      if (_checkWin() == _cpuPiece) {
        return 10 - depth;
      } else if (_checkWin() == _playerPiece) {
        return depth - 10;
      } else {
        return 0;
      }
    }

    if (isMaximizing) {
      int maxScore = -1000;

      for (int i = 0; i < _board.length; i++) {
        for (int j = 0; j < _board[i].length; j++) {
          if (_board[i][j] == "") {
            _board[i][j] = _cpuPiece;
            int score = _minimax(depth + 1, false, alpha, beta);
            _board[i][j] = "";
            maxScore = max(maxScore, score);
            alpha = max(alpha, score);
            if (beta <= alpha) {
              break;
            }
          }
        }
      }

      return maxScore;
    } else {
      int minScore = 1000;

      for (int i = 0; i < _board.length; i++) {
        for (int j = 0; j < _board[i].length; j++) {
          if (_board[i][j] == "") {
            _board[i][j] = _playerPiece;
            int score = _minimax(depth + 1, true, alpha, beta);
            _board[i][j] = "";
            minScore = min(minScore, score);
            beta = min(beta, score);
            if (beta <= alpha) {
              break;
            }
          }
        }
      }

      return minScore;
    }
  }
  void _makeMove(int row, int col) {
    if (_board[row][col] != "" || _gameOver || !_isPlayerTurn) {
      return;
    }
    setState(() {
      _board[row][col] = _playerPiece;
      _checkWinCon(row, col, _playerPiece);
      if (!_gameOver) {
        _isPlayerTurn = false;
        _cpuMove(_difficultyLevel);
        if (!_gameOver) {
          _isPlayerTurn = true;
        }
      }
      if (_winner != "") {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.noHeader,
          animType: AnimType.rightSlide,
          btnOkText: "Play Again",
          btnOkColor: Colors.red,
          title: _winner == "Player"
              ? "Player Won!"
              : _winner == "CPU"
                  ? "CPU Won"
                  : "It's a tie!",
          btnOkOnPress: () {
            _updateDifficultyLevel(_difficultyLevel);
          },
        ).show();
      }
    });
  }

  void _updateDifficultyLevel(int level) {
    _resetGame();
    setState(() {
      _difficultyLevel = level;
      if (!_isPlayerTurn) {
        _cpuMove(_difficultyLevel);
        _isPlayerTurn = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
      ),
    );
    if (_difficultyLevel == 0) {
      return Scaffold(
        backgroundColor: Colors.grey[900],
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () {
                  _updateDifficultyLevel(1);
                },
                child: SizedBox(
                  width: 90,
                  height: 35,
                  child: Row(
                    children: const [
                      Icon(Icons.child_care, color: Colors.white),
                      SizedBox(width: 8),
                      Text('Easy'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () {
                  _updateDifficultyLevel(2);
                },
                child: SizedBox(
                  width: 90,
                  height: 35,
                  child: Row(
                    children: const [
                      Icon(Icons.adb_sharp, color: Colors.white),
                      SizedBox(width: 8),
                      Text('Hard'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: Colors.grey[900],
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Player's piece is: ",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Image.asset(
                      _playerPiece == 'X'
                          ? 'assets/x.png'
                          : 'assets/circle.png',
                      height: 40, // Adjust the height as needed
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 9,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3),
                    itemBuilder: (BuildContext context, int index) {
                      int row = index ~/ 3;
                      int col = index % 3;
                      return GestureDetector(
                        onTap: () => _makeMove(row, col),
                        child: Container(
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          // decoration: BoxDecoration(
                          //   color: Colors.white,
                          // ),
                          child: Image.asset(
                            _board[row][col] == 'X'
                                ? 'assets/x.png'
                                : _board[row][col] == 'O'
                                    ? 'assets/circle.png'
                                    : 'assets/nothing.png',
                          ),
                        ),
                      );
                    }),
              ],
            ),
          ),
        ),
      );
    }
  }
}

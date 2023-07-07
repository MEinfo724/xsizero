import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PlayerVsPlayer extends StatefulWidget {
  const PlayerVsPlayer({Key? key}) : super(key: key);
  @override
  State<PlayerVsPlayer> createState() => _PlayerVsPlayerState();
}

class _PlayerVsPlayerState extends State<PlayerVsPlayer> {
  late List<List<String>> _board;
  late bool _gameOver;
  late String _winner;
  late String _currPlayer;

  @override
  void initState() {
    super.initState();
    _board = List.generate(3, (_) => List.generate(3, (_) => ""));
    _currPlayer = "X";
    _gameOver = false;
    _winner = "";
  }

  void _resetGame() {
    setState(() {
      _board = List.generate(3, (_) => List.generate(3, (_) => ""));
      _currPlayer = "X";
      _gameOver = false;
      _winner = "";
    });
  }

  void _checkWinCon(int row, int col) {
    if (_board[row][0] == _currPlayer &&
        _board[row][1] == _currPlayer &&
        _board[row][2] == _currPlayer) {
      _gameOver = true;
      _winner = _currPlayer;
    }
    if (_board[0][col] == _currPlayer &&
        _board[1][col] == _currPlayer &&
        _board[2][col] == _currPlayer) {
      _gameOver = true;
      _winner = _currPlayer;
    }
    if (_board[0][0] == _currPlayer &&
        _board[1][1] == _currPlayer &&
        _board[2][2] == _currPlayer) {
      _gameOver = true;
      _winner = _currPlayer;
    }
    if (_board[0][2] == _currPlayer &&
        _board[1][1] == _currPlayer &&
        _board[2][0] == _currPlayer) {
      _gameOver = true;
      _winner = _currPlayer;
    }
    //tie condition
    if (!_gameOver) {
      if (!_board.any((row) => row.any((cell) => cell == ""))) {
        _gameOver = true;
        _winner = "It's a tie!";
      }
    }
  }

  void _makeMove(int row, int col) {
    if (_board[row][col] != "" || _gameOver) {
      return;
    }
    setState(() {
      _board[row][col] = _currPlayer;
      _checkWinCon(row, col);
      if (!_gameOver) {
        _currPlayer = _currPlayer == "X" ? "O" : "X";
      }
      if (_winner != "") {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.noHeader,
          animType: AnimType.rightSlide,
          btnOkText: "Play Again",
          btnOkColor: Colors.red,
          title: _winner == "X"
              ? "X Won!"
              : _winner == "O"
                  ? "O Won"
                  : "It's a tie!",
          btnOkOnPress: () {
            _resetGame();
          },
        ).show();
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
                    "Turn: ",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Image.asset(
                    _currPlayer == 'X' ? 'assets/x.png' : 'assets/circle.png',
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

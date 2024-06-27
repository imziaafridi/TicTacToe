import 'package:flutter/material.dart';

import 'consts/app_colors.dart';

class TicTacToeGameView extends StatefulWidget {
  const TicTacToeGameView({super.key});

  @override
  State<TicTacToeGameView> createState() => _TicTacToeGameViewState();
}

class _TicTacToeGameViewState extends State<TicTacToeGameView> {
  late List<List<String>> board;

  late String playerTurn;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initGame();
  }

  void initGame() {
    setState(() {
      board = List.generate(
        3,
        (_) => List.filled(3, ''),
      );
      playerTurn = 'assets/images/x.png';
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    String winner = winnerDecider();
    return Scaffold(
      body: Container(
        // color: const Color.fromARGB(255, 90, 79, 207),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 228, 181, 255),
              Color.fromARGB(255, 158, 68, 211),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 25,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 40,
              ),
              MultiTextRow(
                leadText: 'It\'s',
                cetreText: playerTurn,
                trailText: 'turn',
              ),
              const SizedBox(
                height: 20,
              ),
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemCount: 9,
                itemBuilder: (context, index) {
                  int row = index ~/ 3;
                  int col = index % 3;
                  // Determine borders
                  BorderSide borderSide = const BorderSide(
                    color: Colors.white,
                    width: 4.0,
                  );
                  Border border = Border(
                    top: row > 0 ? borderSide : BorderSide.none,
                    right: col < 2 ? borderSide : BorderSide.none,
                    bottom: row < 2 ? borderSide : BorderSide.none,
                    left: col > 0 ? borderSide : BorderSide.none,
                  );
                  return GestureDetector(
                    onTap: () {
                      if (board[row][col].isEmpty) {
                        setState(() {
                          board[row][col] = playerTurn;
                          playerTurn = (playerTurn == 'assets/images/x.png')
                              ? 'assets/images/o.png'
                              : 'assets/images/x.png';
                        });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: border,
                        // color: Colors.white,
                      ),
                      child: Center(
                        child: board[row][col].isNotEmpty
                            ? Image.asset(
                                board[row][col],
                                height: 70,
                              )
                            : const SizedBox(),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 30,
              ),
              // winner decider
              if (winner.isNotEmpty)
                MultiTextRow(
                  leadText: 'It\'s ',
                  cetreText: winner == 'Draw' ? 'Draw' : winner,
                  trailText: winner == 'Draw' ? 'Ohh !' : 'won !',
                  isImage: winner,
                ),
              const SizedBox(
                height: 30,
              ),
              // reset button
              GestureDetector(
                onTap: () {
                  // if (board[row][col].isEmpty) {
                  //   return;
                  // }

                  setState(() {
                    initGame();
                  });
                },
                child: Container(
                  width: size.width * .4,
                  height: size.height / 15,
                  decoration: BoxDecoration(
                    // color: AppColors.b2,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: AppColors.b2,
                    ),
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 211, 144, 249),
                        Color.fromARGB(255, 158, 68, 211),
                      ],
                      begin: Alignment.topRight,
                      end: Alignment.bottomCenter,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        offset: Offset(0, 0),
                        blurRadius: 20,
                        spreadRadius: 4,
                        blurStyle: BlurStyle.normal,
                        color: AppColors.b2,
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.restart_alt,
                        color: AppColors.b1,
                        size: 28,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        'Reset',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: AppColors.b1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String winnerDecider() {
    for (int i = 0; i < 3; i++) {
      if (board[i][0] == board[i][1] &&
          board[i][1] == board[i][2] &&
          board[i][0].isNotEmpty) {
        return board[i][0];
      }
      if (board[0][i] == board[1][i] &&
          board[1][i] == board[2][i] &&
          board[0][i].isNotEmpty) {
        return board[0][i];
      }
    }

    if (board[0][2] == board[1][1] &&
        board[1][1] == board[2][0] &&
        board[0][2].isNotEmpty) {
      return board[0][2];
    }
    if (board[0][0] == board[1][1] &&
        board[1][1] == board[2][2] &&
        board[0][0].isNotEmpty) {
      return board[0][0];
    }

    bool isDraw = true;

    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i][j].isEmpty) {
          isDraw = false;
        }
      }
    }
    if (isDraw) {
      return 'Draw';
    }
    return '';
  }
}

class MultiTextRow extends StatelessWidget {
  const MultiTextRow({
    super.key,
    // required this.playerTurn,
    this.leadText,
    required this.cetreText,
    this.trailText,
    this.isImage,
  });

  // final String playerTurn;
  final String? leadText;
  final String cetreText;
  final String? trailText;
  final String? isImage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          leadText ?? "It's",
          style: const TextStyle(
            fontSize: 40,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        (isImage != 'Draw')
            ? Image.asset(
                cetreText,
                height: 40,
                color: AppColors.IRIS,
              )
            : Text(
                cetreText,
                style: const TextStyle(
                  fontSize: 35,
                  letterSpacing: 1.2,
                ),
              ),
        const SizedBox(
          width: 8,
        ),
        Text(
          trailText ?? 'turn',
          style: const TextStyle(
            fontSize: 40,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}

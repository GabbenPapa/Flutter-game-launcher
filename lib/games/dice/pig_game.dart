import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../providers/game_provider.dart';

class PigGameScreen extends StatefulWidget {
  static const routeName = '/pig_game';

  const PigGameScreen({super.key});

  @override
  State<PigGameScreen> createState() => _PigGameScreenState();
}

class _PigGameScreenState extends State<PigGameScreen> {
  List<int> scores = [0, 0];
  int currentScore = 0;
  int activePlayer = 0;
  bool playing = true;
  final Random _random = Random();
  int _currentDice = 1;
  bool isRolling = false;

  void switchPlayer() {
    setState(() {
      currentScore = 0;
      activePlayer = activePlayer == 0 ? 1 : 0;
    });
  }

  Future<void> _rollDice() async {
    setState(() => isRolling = true);
    for (int i = 0; i < 10; i++) {
      await Future.delayed(const Duration(milliseconds: 100));
      setState(() {
        _currentDice = _random.nextInt(6) + 1;
      });
    }
    setState(() {
      if (_currentDice != 1) {
        currentScore += _currentDice;
      } else {
        switchPlayer();
      }
      isRolling = false;
    });
  }

  void hold() {
    if (playing) {
      setState(() {
        scores[activePlayer] += currentScore;
        if (scores[activePlayer] >= 100) {
          playing = false;
          showWinnerDialog();
        } else {
          switchPlayer();
        }
      });
    }
  }

  void newGame() {
    setState(() {
      scores = [0, 0];
      currentScore = 0;
      activePlayer = 0;
      playing = true;
      isRolling = false;
      _currentDice = 1;
    });
  }

  void showWinnerDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.winnerTitle),
          content: Text(
            AppLocalizations.of(context)!.winnerMessage(activePlayer + 1),
          ),
          backgroundColor: Colors.pink,
          actions: [
            TextButton(
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
                backgroundColor: WidgetStateProperty.all<Color>(Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                newGame();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameId = ModalRoute.of(context)!.settings.arguments as String;
    final loadedGames = Provider.of<GameProvider>(
      context,
      listen: false,
    ).findById(gameId);

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedGames.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.replay),
            onPressed: newGame,
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red, Colors.purple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.0, 1.0],
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 200,
                          child: Card(
                            color: activePlayer == 0
                                ? Colors.pink[100]
                                : Colors.pink[400],
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.player1,
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    '${AppLocalizations.of(context)!.score} ${scores[0]}',
                                    style: const TextStyle(fontSize: 32),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    '${AppLocalizations.of(context)!.current} ${activePlayer == 0 ? currentScore : 0}',
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                'assets/images/dice-$_currentDice.png',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 200,
                          child: Card(
                            color: activePlayer != 0
                                ? Colors.pink[100]
                                : Colors.pink[400],
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.player2,
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    '${AppLocalizations.of(context)!.score} ${scores[1]}',
                                    style: const TextStyle(fontSize: 32),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    '${AppLocalizations.of(context)!.current} ${activePlayer == 1 ? currentScore : 0}',
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: SizedBox(
                          height: 80,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  !isRolling ? Colors.green : Colors.red,
                            ),
                            onPressed: isRolling ? null : hold,
                            child: Text(
                              AppLocalizations.of(context)!.hold,
                              style: const TextStyle(fontSize: 25),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: SizedBox(
                          height: 80,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  !isRolling ? Colors.green : Colors.red,
                            ),
                            onPressed: isRolling ? null : _rollDice,
                            child: Text(
                              AppLocalizations.of(context)!.rollDice,
                              style: const TextStyle(fontSize: 25),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ],
      ),
    );
  }
}

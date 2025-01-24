import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';

import '../../theme/themes.dart';
import 'darts_manager.dart';
import 'keyboard.dart';

class DartsGameScreen extends StatefulWidget {
  static const routeName = '/darts_game';

  const DartsGameScreen({super.key});

  @override
  DartsGameScreenState createState() => DartsGameScreenState();
}

class DartsGameScreenState extends State<DartsGameScreen> {
  late List<int> playerScores = [];
  late DartsGameArguments args;
  late List<String> playerNames = [];
  late List<PlayerStat> playerStats;

  int currentPlayer = 0;

  final TextEditingController _controller = TextEditingController();
  final TextEditingController _playerNameController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    _controller.dispose();
    _playerNameController.dispose();
    _focusNode.dispose();

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      args = ModalRoute.of(context)!.settings.arguments as DartsGameArguments;

      playerScores = List.filled(args.numberOfPlayers, args.targetScore);
      playerNames =
          List.generate(args.numberOfPlayers, (index) => 'Player ${index + 1}');

      _initializePlayers();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });

      _isInitialized = true;
    }
  }

  void _initializePlayers() {
    playerStats = [
      for (var i = 0; i < args.numberOfPlayers; i++)
        PlayerStat(name: playerNames[i]),
    ];
  }

  void _checkWinner() {
    setState(() {
      var currentPlayerStat = playerStats[currentPlayer];
      currentPlayerStat.incrementLegs();

      if (currentPlayerStat.winnedLegs >= args.legs) {
        currentPlayerStat.incrementSets();
        _resetAllPlayersLegs();

        if (currentPlayerStat.winnedSets >= args.sets) {
          Future.delayed(const Duration(milliseconds: 100), () {
            showWinnerDialog(isFinal: true);
          });
          return;
        }
      }
    });
  }

  void _updateScore(bool doubleMode, bool tripleMode) {
    int enteredPoints = int.tryParse(_controller.text) ?? 0;

    if (doubleMode) {
      enteredPoints *= 2;
    } else if (tripleMode) {
      enteredPoints *= 3;
    }

    if (enteredPoints > 180) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.invalidPoints),
        ),
      );
      _focusNode.requestFocus();
      _controller.clear();
      return;
    }

    setState(() {
      int newScore = playerScores[currentPlayer] - enteredPoints;

      if (args.doubleOut && newScore < 2 && newScore != 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.doubleOutMinimumPoints),
          ),
        );
        _controller.clear();
        _focusNode.requestFocus();
        return;
      }

      if (newScore == 0) {
        _controller.clear();

        _checkWinner();

        if (playerStats[currentPlayer].winnedSets != args.sets) {
          showWinnerDialog();
        }
        return;
      }

      if (newScore < 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.invalidPoints),
          ),
        );
        _controller.clear();
        _focusNode.requestFocus();
        return;
      }

      playerScores[currentPlayer] = newScore;

      currentPlayer = (currentPlayer + 1) % args.numberOfPlayers;

      _controller.clear();
      _focusNode.requestFocus();
    });
  }

  void _resetAllPlayersLegs() {
    for (var stats in playerStats) {
      stats.resetLegs();
    }
  }

  void _startNewGame() {
    setState(() {
      playerScores = List.filled(args.numberOfPlayers, args.targetScore);
      currentPlayer = 0;
    });
  }

  void editNameDialog(int index) {
    _playerNameController.text = '';
    final theme = Theme.of(context);
    final customTheme = theme.extension<CustomThemeExtension>();

    var oldName = playerNames[index];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.editNameTitle),
          content: TextField(
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            controller: _playerNameController,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.enterName,
            ),
          ),
          backgroundColor: customTheme?.dartsBGColor,
          actions: [
            TextButton(
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
                backgroundColor: WidgetStateProperty.all<Color>(Colors.black),
              ),
              onPressed: () {
                setState(() {
                  if (_playerNameController.text.isEmpty) {
                    _playerNameController.text = oldName;
                  } else {
                    playerNames[index] = _playerNameController.text;
                  }
                });

                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void showWinnerDialog({bool isFinal = false}) {
    final theme = Theme.of(context);
    final customTheme = theme.extension<CustomThemeExtension>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: isFinal
              ? Text(AppLocalizations.of(context)!.finalWinnerTitle)
              : Text(AppLocalizations.of(context)!.winnerTitle),
          content: Text(
            AppLocalizations.of(context)!
                .winnerMessage(playerNames[currentPlayer]),
          ),
          backgroundColor: customTheme?.dartsBGColor,
          actions: [
            TextButton(
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
                backgroundColor: WidgetStateProperty.all<Color>(Colors.black),
              ),
              onPressed: () {
                if (!isFinal) {
                  _startNewGame();
                } else {
                  Navigator.of(context).pop();
                }
                Navigator.of(context).pop();
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
    final theme = Theme.of(context);
    final customTheme = theme.extension<CustomThemeExtension>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        title: Text(
          AppLocalizations.of(context)!.gameMode(args.targetScore.toString()),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            Navigator.of(context).pop();
          },
        ),
      ),
      body: DoubleBackToCloseApp(
        snackBar: SnackBar(
          content: Text(
            AppLocalizations.of(context)!.pressBackAgainToExit,
          ),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: customTheme?.backgroundGradient,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        _playersTable(),
                        const SizedBox(height: 16.0),
                        _scoreCard(theme),
                        const SizedBox(height: 16.0),
                        _setsAndLegs(theme),
                      ],
                    ),
                  ),
                  CustomKeyboard(
                    controller: _controller,
                    onKeyTapped: (key) {
                      setState(() {
                        _controller.text += key;
                      });
                    },
                    onDoneTapped: () {
                      _updateScore(false, false);
                    },
                    onDoneTappedWithModifiers: (doubleMode, tripleMode) {
                      _updateScore(doubleMode, tripleMode);
                    },
                    onBackspaceTapped: () {
                      setState(() {
                        if (_controller.text.isNotEmpty) {
                          _controller.text = _controller.text
                              .substring(0, _controller.text.length - 1);
                        }
                      });
                    },
                    onBackTapped: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _playersTable() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        args.numberOfPlayers,
        (index) => Expanded(
          child: Column(
            children: [
              GestureDetector(
                child: Text(
                  playerNames[index],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color:
                        index == currentPlayer ? Colors.orange : Colors.white,
                  ),
                ),
                onTap: () {
                  editNameDialog(index);
                },
              ),
              const Divider(
                thickness: 1,
                color: Colors.white,
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: index == currentPlayer && playerScores[index] < 170
                      ? Colors.green
                      : Colors.transparent,
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    '${playerScores[index]}',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color:
                          index == currentPlayer ? Colors.orange : Colors.white,
                    ),
                  ),
                ),
              ),
              const Divider(
                thickness: 1,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _scoreCard(theme) {
    final theme = Theme.of(context);
    final customTheme = theme.extension<CustomThemeExtension>();

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: customTheme?.dartsBGColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            playerNames[currentPlayer],
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.orange,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Score: ${playerScores[currentPlayer]}',
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _setsAndLegs(theme) {
    final theme = Theme.of(context);
    final customTheme = theme.extension<CustomThemeExtension>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Text(
              AppLocalizations.of(context)!.sets,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: customTheme?.dartsTextColor),
            ),
            const SizedBox(height: 4),
            Text(
              '${args.sets}/${playerStats[currentPlayer].winnedSets}',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: customTheme?.dartsTextColor),
            ),
          ],
        ),
        Column(
          children: [
            Text(
              AppLocalizations.of(context)!.legs,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: customTheme?.dartsTextColor),
            ),
            const SizedBox(height: 4),
            Text(
              '${args.legs}/${playerStats[currentPlayer].winnedLegs}',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: customTheme?.dartsTextColor),
            ),
          ],
        ),
      ],
    );
  }
}

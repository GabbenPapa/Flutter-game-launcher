import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../providers/game_provider.dart';
import '../../theme/themes.dart';

class RpsGameScreen extends StatefulWidget {
  static const routeName = '/rps_game';

  const RpsGameScreen({super.key});

  @override
  State<RpsGameScreen> createState() => _RpsGameScreenState();
}

class _RpsGameScreenState extends State<RpsGameScreen> {
  final List<Map<String, String>> choices = [
    {'name': 'Rock', 'image': 'assets/images/rock.png'},
    {'name': 'Paper', 'image': 'assets/images/paper.png'},
    {'name': 'Scissors', 'image': 'assets/images/scissors.png'},
  ];

  bool _isRunning = false;

  String? playerChoice;
  Map<String, String>? computerChoice;
  String resultMessage = '';

  void playGame(String choice) {
    setState(() {
      _isRunning = true;
      playerChoice = choice;
      computerChoice = choices[Random().nextInt(choices.length)];
      resultMessage = getResult(playerChoice!, computerChoice!['name']!);
      _isRunning = false;
    });
  }

  String getResult(String player, String computer) {
    if (player == computer) return AppLocalizations.of(context)!.itsADraw;
    if ((player == 'Rock' && computer == 'Scissors') ||
        (player == 'Paper' && computer == 'Rock') ||
        (player == 'Scissors' && computer == 'Paper')) {
      return AppLocalizations.of(context)!.youWin;
    }
    return AppLocalizations.of(context)!.youLose;
  }

  @override
  Widget build(BuildContext context) {
    final gameId = ModalRoute.of(context)!.settings.arguments as String;
    final loadedGames = Provider.of<GameProvider>(
      context,
      listen: false,
    ).findById(gameId);

    final theme = Theme.of(context);
    final customTheme = theme.extension<CustomThemeExtension>();

    return Scaffold(
      appBar: AppBar(title: Text(loadedGames.title)),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: customTheme?.backgroundGradient,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.chooseYourMove,
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: choices.map(
                        (choice) {
                          bool isSelected = playerChoice == choice['name'];
                          return Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: ClipOval(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: isSelected
                                      ? Border.all(
                                          color: customTheme?.selectedColor ??
                                              Colors.grey,
                                          width: 4,
                                        )
                                      : null,
                                  shape: BoxShape.circle,
                                ),
                                width: 120,
                                height: 120,
                                child: IconButton(
                                  icon: ClipOval(
                                    child: Image.asset(
                                      choice['image']!,
                                      fit: BoxFit.cover,
                                      width: 120,
                                      height: 120,
                                    ),
                                  ),
                                  onPressed: () => playGame(choice['name']!),
                                ),
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _isRunning
                          ? AppLocalizations.of(context)!.playing
                          : resultMessage,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Center(
                  child: SizedBox(
                    width: 170,
                    height: 170,
                    child: ClipOval(
                      child: computerChoice != null
                          ? Image.asset(
                              computerChoice!['image']!,
                              fit: BoxFit.cover,
                            )
                          : Container(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ],
      ),
    );
  }
}

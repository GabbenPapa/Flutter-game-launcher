import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:game_launcher/games/darts/darts_game_screen.dart';
import 'package:provider/provider.dart';
import '../../providers/game_provider.dart';
import '../../theme/themes.dart';
import 'darts_manager.dart';

class DartsSetupScreen extends StatefulWidget {
  static const routeName = '/darts_setup';

  const DartsSetupScreen({super.key});

  @override
  DartsSetupScreenState createState() => DartsSetupScreenState();
}

class DartsSetupScreenState extends State<DartsSetupScreen> {
  int selectedSet = 2;
  int selectedLeg = 2;
  int numberOfPlayers = 2;
  int selectedScore = 301;
  bool doubleOut = false;

  late FixedExtentScrollController setController;
  late FixedExtentScrollController legController;

  @override
  void initState() {
    super.initState();
    setController = FixedExtentScrollController(initialItem: selectedSet - 1);
    legController = FixedExtentScrollController(initialItem: selectedLeg - 1);
  }

  @override
  void dispose() {
    setController.dispose();
    legController.dispose();
    super.dispose();
  }

  final scores = [101, 201, 301, 501, 701, 1001];
  final players = [2, 3, 4];

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
      appBar: AppBar(
        title: Text(loadedGames.title),
      ),
      body: Stack(
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
                const SizedBox(height: 20),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Sets list
                          _buildScrollSelector(
                            label: AppLocalizations.of(context)!.sets,
                            itemCount: 5,
                            selectedValue: selectedSet,
                            controller: setController,
                            onChanged: (value) {
                              setState(() {
                                selectedSet = value + 1;
                              });
                            },
                          ),
                          // Legs list
                          _buildScrollSelector(
                            label: AppLocalizations.of(context)!.legs,
                            itemCount: 5,
                            selectedValue: selectedLeg,
                            controller: legController,
                            onChanged: (value) {
                              setState(() {
                                selectedLeg = value + 1;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Target selector
                      Text(
                        AppLocalizations.of(context)!.targetScore,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      _scoreSelector(),

                      const SizedBox(height: 20),

                      Text(
                        AppLocalizations.of(context)!.doubleOut,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Switch(
                        value: doubleOut,
                        onChanged: (value) {
                          setState(() {
                            doubleOut = value;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      Text(
                        AppLocalizations.of(context)!.players,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),

                      _playerSelector(),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 80,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () {
                      final arguments = DartsGameArguments(
                        sets: selectedSet,
                        legs: selectedLeg,
                        targetScore: selectedScore,
                        doubleOut: doubleOut,
                        numberOfPlayers: numberOfPlayers,
                      );
                      Navigator.pushNamed(
                        context,
                        DartsGameScreen.routeName,
                        arguments: arguments,
                      );
                    },
                    child: Text(
                      AppLocalizations.of(context)!.letsplay,
                      style: const TextStyle(fontSize: 25),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScrollSelector({
    required String label,
    required int itemCount,
    required int selectedValue,
    required FixedExtentScrollController controller,
    required ValueChanged<int> onChanged,
  }) {
    final theme = Theme.of(context);
    final customTheme = theme.extension<CustomThemeExtension>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 200,
          width: 100,
          child: ListWheelScrollView.useDelegate(
            controller: controller,
            itemExtent: 50,
            perspective: 0.003,
            diameterRatio: 1.5,
            onSelectedItemChanged: onChanged,
            physics: const FixedExtentScrollPhysics(),
            childDelegate: ListWheelChildBuilderDelegate(
              builder: (context, index) => Center(
                child: Container(
                  width: 140,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      style: BorderStyle.solid,
                      color: index == selectedValue - 1
                          ? Colors.orange
                          : Colors.transparent,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      (index + 1).toString(),
                      style: TextStyle(
                        fontSize: 24,
                        color: index == selectedValue - 1
                            ? Colors.orange
                            : customTheme?.dartsTextColor,
                        fontWeight: index == selectedValue - 1
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
              childCount: itemCount,
            ),
          ),
        ),
      ],
    );
  }

  Widget _scoreSelector() {
    final theme = Theme.of(context);
    final customTheme = theme.extension<CustomThemeExtension>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: scores.map((score) {
        final isSelected = selectedScore == score;

        return GestureDetector(
          onTap: () {
            setState(() {
              selectedScore = score;
            });
          },
          child: Container(
            width: 50,
            padding: const EdgeInsets.symmetric(
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? customTheme?.selectedColor
                  : customTheme?.unselectedColor,
              border: Border.all(
                color: customTheme?.borderColor ?? Colors.grey,
                width: 1,
              ),
            ),
            child: Text(
              score.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: customTheme?.dartsTextColor,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _playerSelector() {
    final theme = Theme.of(context);
    final customTheme = theme.extension<CustomThemeExtension>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: players.map((playerNum) {
        final isSelected = numberOfPlayers == playerNum;

        return GestureDetector(
          onTap: () {
            setState(() {
              numberOfPlayers = playerNum;
            });
          },
          child: Container(
            width: 50,
            padding: const EdgeInsets.symmetric(
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? customTheme?.selectedColor
                  : customTheme?.unselectedColor,
              border: Border.all(
                color: customTheme?.borderColor ?? Colors.grey,
                width: 1,
              ),
            ),
            child: Text(
              playerNum.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: customTheme?.dartsTextColor,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

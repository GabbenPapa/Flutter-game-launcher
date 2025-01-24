import 'dart:async';
import 'dart:math';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../../providers/game_provider.dart';

class DiceGameScreen extends StatefulWidget {
  static const routeName = '/dice_game';

  const DiceGameScreen({super.key});

  @override
  DiceGameScreenState createState() => DiceGameScreenState();
}

class DiceGameScreenState extends State<DiceGameScreen> {
  final Random _random = Random();
  int _currentDice = 1;
  bool _isRolling = false;
  StreamSubscription? _accelerometerSubscription;
  DateTime _lastShakeTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _startShakeListener();
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  Future<void> _rollDice() async {
    setState(() => _isRolling = true);
    for (int i = 0; i < 10; i++) {
      await Future.delayed(const Duration(milliseconds: 100));
      setState(() {
        _currentDice = _random.nextInt(6) + 1;
      });
    }
    setState(() => _isRolling = false);
  }

  void _startShakeListener() {
    _accelerometerSubscription = accelerometerEventStream().listen((event) {
      final double acceleration =
          sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
      final DateTime now = DateTime.now();

      if (acceleration > 15 &&
          !_isRolling &&
          now.difference(_lastShakeTime) > const Duration(seconds: 2)) {
        _lastShakeTime = now;
        _rollDice();
      }
    });
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/images/dice-$_currentDice.png',
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    if (!_isRolling)
                      Text(
                        '${AppLocalizations.of(context)!.youRolled}: $_currentDice',
                        style: const TextStyle(fontSize: 20),
                      )
                    else
                      Text(
                        AppLocalizations.of(context)!.rolling,
                        style: const TextStyle(fontSize: 20),
                      ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 80,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              !_isRolling ? Colors.green : Colors.red,
                        ),
                        onPressed: _isRolling ? null : _rollDice,
                        child: Text(
                          AppLocalizations.of(context)!.rollDice,
                          style: const TextStyle(fontSize: 25),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

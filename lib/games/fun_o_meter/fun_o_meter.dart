import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../providers/game_provider.dart';
import '../../theme/themes.dart';

class FunOMeter extends StatefulWidget {
  static const routeName = '/fun_o_meter';

  const FunOMeter({super.key});

  @override
  State<FunOMeter> createState() => _FunOMeterState();
}

class _FunOMeterState extends State<FunOMeter> {
  double _pointerValue = 0;

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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SfRadialGauge(
                axes: <RadialAxis>[
                  RadialAxis(
                    minimum: 0,
                    maximum: 100,
                    pointers: <GaugePointer>[
                      NeedlePointer(value: _pointerValue), // Mutató értéke
                    ],
                    annotations: <GaugeAnnotation>[
                      GaugeAnnotation(
                        widget: Text(
                          _pointerValue.toStringAsFixed(0),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        angle: 90,
                        positionFactor: 0.5,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Slider(
                value: _pointerValue,
                min: 0,
                max: 100,
                divisions: 100,
                label: _pointerValue.toStringAsFixed(0),
                onChanged: (value) {
                  setState(() {
                    _pointerValue = value;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
              Text(AppLocalizations.of(context)!.fun_o_meter,
                  style: theme.textTheme.headlineLarge),
              const SizedBox(height: 50),
              SfRadialGauge(
                axes: <RadialAxis>[
                  RadialAxis(
                    startAngle: 180,
                    endAngle: 0,
                    minimum: 0,
                    maximum: 101,
                    ranges: <GaugeRange>[
                      GaugeRange(
                        startValue: 0,
                        endValue: 33,
                        color: Colors.red,
                        startWidth: 10,
                        endWidth: 10,
                      ),
                      GaugeRange(
                        startValue: 33,
                        endValue: 66,
                        color: Colors.yellow,
                        startWidth: 10,
                        endWidth: 10,
                      ),
                      GaugeRange(
                        startValue: 66,
                        endValue: 101,
                        color: Colors.green,
                        startWidth: 10,
                        endWidth: 10,
                      ),
                    ],
                    pointers: <GaugePointer>[
                      NeedlePointer(value: _pointerValue),
                    ],
                    annotations: <GaugeAnnotation>[
                      GaugeAnnotation(
                        widget: Text(
                          _pointerValue.toStringAsFixed(0),
                          style: const TextStyle(
                            fontSize: 40,
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
                activeColor: customTheme?.selectedColor,
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

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

import '../theme/themes.dart';

class BigCard extends StatelessWidget {
  const BigCard({
    required this.pair,
    super.key,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customTheme = theme.extension<CustomThemeExtension>();

    return Card(
      color: customTheme?.cardBackgroundColor ?? Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: MergeSemantics(
          child: Wrap(
            children: [
              Text(
                pair.first,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w200,
                  color: customTheme?.cardTextColor ?? Colors.black,
                ),
              ),
              Text(
                pair.second,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: customTheme?.cardTextColor ?? Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

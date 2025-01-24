import 'package:flutter/material.dart';
import '../../theme/themes.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomKeyboard extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onKeyTapped;
  final VoidCallback onBackspaceTapped;
  final VoidCallback onDoneTapped;
  final Function(bool, bool) onDoneTappedWithModifiers;
  final VoidCallback onBackTapped;

  const CustomKeyboard({
    super.key,
    required this.controller,
    required this.onKeyTapped,
    required this.onBackspaceTapped,
    required this.onDoneTapped,
    required this.onDoneTappedWithModifiers,
    required this.onBackTapped,
  });

  @override
  State<CustomKeyboard> createState() => _CustomKeyboardState();
}

class _CustomKeyboardState extends State<CustomKeyboard> {
  bool doubleModeActive = false;
  bool tripleModeActive = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customTheme = theme.extension<CustomThemeExtension>();
    // final screenWidth = MediaQuery.of(context).size.width;
    // final keyButtonWidth = ((screenWidth - 16 - 12) / 3) - 6;

    void keyDone() {
      widget.onDoneTappedWithModifiers(doubleModeActive, tripleModeActive);
      if (doubleModeActive || tripleModeActive) {
        setState(() {
          doubleModeActive = false;
          tripleModeActive = false;
        });
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // _buildKeyButton(
                  //   context: context,
                  //   text: AppLocalizations.of(context)!.double,
                  //   onPressed: () {
                  //     setState(() {
                  //       doubleModeActive = !doubleModeActive;
                  //       if (tripleModeActive) {
                  //         tripleModeActive = false;
                  //       }
                  //     });
                  //   },
                  //   isActive: doubleModeActive,
                  //   width: keyButtonWidth,
                  //   height: 50,
                  // ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: SizedBox(
                        child: TextField(
                          controller: widget.controller,
                          readOnly: true,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 20.0),
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 10.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                color: customTheme?.dartsBGColor ?? Colors.grey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                color: customTheme?.dartsBGColor ?? Colors.grey,
                              ),
                            ),
                            filled: true,
                            fillColor: customTheme?.dartsBGColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // _buildKeyButton(
                  //   context: context,
                  //   text: AppLocalizations.of(context)!.triple,
                  //   onPressed: () {
                  //     setState(() {
                  //       tripleModeActive = !tripleModeActive;
                  //       if (doubleModeActive) {
                  //         doubleModeActive = false;
                  //       }
                  //     });
                  //   },
                  //   isActive: tripleModeActive,
                  //   width: keyButtonWidth,
                  //   height: 50,
                  // ),
                ],
              ),
              GridView.count(
                crossAxisCount: 3,
                childAspectRatio: 1.5,
                shrinkWrap: true,
                children: [
                  for (int i = 1; i <= 9; i++)
                    _buildKeyButton(
                      context: context,
                      text: '$i',
                      onPressed: () {
                        if (widget.controller.text.length < 3) {
                          widget.onKeyTapped('$i');
                        }
                      },
                    ),
                  _buildKeyButton(
                    context: context,
                    text: '⌫',
                    onPressed: widget.onBackspaceTapped,
                  ),
                  _buildKeyButton(
                    context: context,
                    text: '0',
                    onPressed: () {
                      if (widget.controller.text.length < 3) {
                        widget.onKeyTapped('0');
                      }
                    },
                  ),
                  _buildKeyButton(
                    context: context,
                    text: 'Done',
                    onPressed: keyDone,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildKeyButton({
    required BuildContext context,
    required String text,
    required VoidCallback onPressed,
    bool isActive = false,
    double? width,
    double? height,
  }) {
    final theme = Theme.of(context);
    final customTheme = theme.extension<CustomThemeExtension>();

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SizedBox(
        width: width,
        height: height,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                isActive ? Colors.orange : customTheme?.dartsBGColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            minimumSize: const Size(40, 40),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: customTheme?.dartsTextColor,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

/// Center Text widget
class CenterTextWidget extends StatelessWidget {
  /// Initialise Widget
  const CenterTextWidget({required this.title, Key? key}) : super(key: key);

  /// title for display text
  final String title;

  @override
  Widget build(BuildContext context) => Center(child: Text(title));
}

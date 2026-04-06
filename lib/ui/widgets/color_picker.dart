import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ColorPicker extends StatelessWidget {
  const ColorPicker({
    super.key,
    required this.color,
    required this.onColorChanged,
    required this.label,
  });

  final Color color;
  final ValueChanged<Color> onColorChanged;
  final String label;

  @override
  Widget build(BuildContext context) {
    const themeColors = [
      Colors.red,
      Colors.pink,
      Colors.purple,
      Colors.deepPurple,
      Colors.indigo,
      Colors.blue,
      Colors.lightBlue,
      Colors.cyan,
      Colors.teal,
      Colors.green,
      Colors.lightGreen,
      Colors.lime,
      Colors.yellow,
      Colors.amber,
      Colors.orange,
      Colors.deepOrange,
      Colors.brown,
      Colors.grey,
      Colors.blueGrey,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            label,
            style: ShadTheme.of(context).textTheme.muted,
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: themeColors.map((item) {
            final isSelected = item.toARGB32() == color.toARGB32();
            return GestureDetector(
              onTap: () => onColorChanged(item),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: item,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? ShadTheme.of(context).colorScheme.ring
                        : ShadTheme.of(context)
                            .colorScheme
                            .muted
                            .withValues(alpha: 0.6),
                    width: 2,
                  ),
                ),
                child: isPressed(item, isSelected, context),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget? isPressed(Color item, bool isSelected, BuildContext context) {
    if (!isSelected) return null;
    return Icon(
      LucideIcons.check,
      size: 16,
      color: item.computeLuminance() > 0.5 ? Colors.black : Colors.white,
    );
  }
}

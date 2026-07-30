import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ColorPickerWidget extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onColorSelected;

  const ColorPickerWidget({
    super.key,
    required this.selectedIndex,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: List.generate(
        AppTheme.projectColors.length,
        (index) => GestureDetector(
          onTap: () => onColorSelected(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.projectColors[index],
              shape: BoxShape.circle,
              border: selectedIndex == index
                  ? Border.all(
                      color: Colors.white,
                      width: 3,
                    )
                  : null,
            ),
            child: selectedIndex == index
                ? const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 22,
                  )
                : null,
          ),
        ),
      ),
    );
  }
}

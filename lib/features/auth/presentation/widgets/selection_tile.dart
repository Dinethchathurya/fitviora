import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class SelectionTile extends StatelessWidget {
  final String title;
  final String? leadingEmoji;
  final bool selected;
  final VoidCallback onTap;
  final bool showRadio;

  const SelectionTile({
    super.key,
    required this.title,
    this.leadingEmoji,
    required this.selected,
    required this.onTap,
    this.showRadio = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.emerald50 : AppColors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 16,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? AppColors.emerald500 : AppColors.gray200,
            ),
          ),
          child: Row(
            children: [
              if (leadingEmoji != null) ...[
                Text(
                  leadingEmoji!,
                  style: const TextStyle(fontSize: 22),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.gray900,
                  ),
                ),
              ),
              Icon(
                showRadio
                    ? (selected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off)
                    : (selected
                        ? Icons.check_circle
                        : Icons.circle_outlined),
                color: selected ? AppColors.emerald500 : AppColors.gray300,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

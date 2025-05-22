import 'package:flutter/material.dart'; // Імпорт основної бібліотеки віджетів Flutter

// Віджет ChartBar є StatelessWidget, оскільки його зовнішній вигляд залежить лише від переданого параметра 'fill'
class ChartBar extends StatelessWidget {
  const ChartBar({
    super.key,
    required this.fill,
  }); // Конструктор, який приймає значення заповнення стовпця

  final double fill; // Значення заповнення стовпця (від 0.0 до 1.0)

  @override
  Widget build(BuildContext context) {
    // Визначення, чи використовується темна тема
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Expanded(
      // Віджет Expanded займає доступний горизонтальний простір
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 4,
        ), // Встановлення горизонтальних відступів навколо стовпця
        child: FractionallySizedBox(
          // Віджет FractionallySizedBox встановлює розмір свого дочірнього елемента як частку від доступного простору
          heightFactor:
              fill, // Встановлення висоти стовпця на основі переданого значення 'fill' (від 0 до 1)
          child: DecoratedBox(
            // Віджет DecoratedBox використовується для стилізації стовпця
            decoration: BoxDecoration(
              shape: BoxShape.rectangle, // Форма стовпця - прямокутник
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8), // Заокруглення верхніх кутів стовпця
              ),
              color:
                  isDarkMode // Вибір кольору стовпця залежно від теми
                      ? Theme.of(context)
                          .colorScheme
                          .secondary // Вторинний колір для темної теми
                      : Theme.of(context).colorScheme.primary.withValues(
                        alpha: (0.65 * 255).round().toDouble(),
                      ), // Первинний колір з прозорістю для світлої теми
            ),
          ),
        ),
      ),
    );
  }
}

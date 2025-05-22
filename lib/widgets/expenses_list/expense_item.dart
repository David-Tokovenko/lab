import 'package:flutter/material.dart'; // Імпорт основної бібліотеки віджетів Flutter
import 'package:expense_tracker/models/expense.dart'; // Імпорт файлу з моделлю даних витрати

// Віджет ExpenseItem є StatelessWidget, оскільки він лише відображає дані, які йому передаються
class ExpenseItem extends StatelessWidget {
  const ExpenseItem(
    this.expense, {
    super.key,
  }); // Конструктор, який приймає об'єкт Expense

  final Expense
  expense; // Об'єкт витрати, інформацію про яку потрібно відобразити

  @override
  Widget build(BuildContext context) {
    return Card(
      // Використання віджета Card для візуального оформлення елемента списку
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ), // Встановлення горизонтальних та вертикальних відступів
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment
                  .start, // Вирівнювання вмісту колонки по лівому краю
          children: [
            Text(
              expense.title, // Відображення назви витрати
              style:
                  Theme.of(context)
                      .textTheme
                      .titleLarge, // Використання стилю для великих заголовків з поточної теми
            ),
            const SizedBox(
              height: 4,
            ), // Додавання невеликого вертикального відступу
            Row(
              children: [
                Text(
                  '\$${expense.amount.toStringAsFixed(2)}',
                ), // Відображення суми витрати з двома знаками після коми
                const Spacer(), // Займає все доступне горизонтальне місце, щоб розтягнути елементи
                Text(
                  expense.familyMember.name
                      .toUpperCase(), // Відображення імені члена сім'ї
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                Row(
                  children: [
                    Icon(
                      categoryIcons[expense.category],
                    ), // Відображення іконки, що відповідає категорії витрати (map categoryIcons має бути визначено в expense.dart)
                    const SizedBox(
                      width: 8,
                    ), // Додавання невеликого горизонтального відступу між іконкою та датою
                    Text(
                      expense.formattedDate,
                    ), // Відображення форматованої дати витрати (логіка форматування має бути в моделі Expense)
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
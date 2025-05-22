import 'package:flutter/material.dart'; // Імпорт основної бібліотеки віджетів Flutter
import 'package:expense_tracker/widgets/chart/chart_bar.dart'; // Імпорт файлу з віджетом для відображення одного стовпця діаграми
import 'package:expense_tracker/models/expense.dart'; // Імпорт файлу з моделлю даних витрати

class Chart extends StatelessWidget {
  const Chart({
    super.key,
    required this.expenses,
  });

  final List<Expense> expenses;

  List<ExpenseBucket> get categoryBuckets {
    return [
      ExpenseBucket.forCategory(expenses, Category.food),
      ExpenseBucket.forCategory(expenses, Category.leisure),
      ExpenseBucket.forCategory(expenses, Category.travel),
      ExpenseBucket.forCategory(expenses, Category.work),
      ExpenseBucket.forCategory(expenses, Category.entertainment),
    ];
  }

  List<FamilyMemberExpenseBucket> get familyMemberBuckets {
    return [
      FamilyMemberExpenseBucket.forFamilyMember(expenses, FamilyMember.father),
      FamilyMemberExpenseBucket.forFamilyMember(expenses, FamilyMember.mother),
      FamilyMemberExpenseBucket.forFamilyMember(expenses, FamilyMember.son),
      FamilyMemberExpenseBucket.forFamilyMember(expenses, FamilyMember.dauther),
    ];
  }

  double get maxTotalCategoryExpense {
    double maxTotalExpense = 0;
    for (final bucket in categoryBuckets) {
      if (bucket.totalExpenses > maxTotalExpense) {
        maxTotalExpense = bucket.totalExpenses;
      }
    }
    return maxTotalExpense;
  }

  double get maxTotalFamilyMemberExpense {
    double maxTotalExpense = 0;
    for (final bucket in familyMemberBuckets) {
      if (bucket.totalExpenses > maxTotalExpense) {
        maxTotalExpense = bucket.totalExpenses;
      }
    }
    return maxTotalExpense;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      width: double.infinity,
      height: 300, // Збільшено висоту для розміщення обох графіків
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.3),
            Colors.transparent,
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      child: Column(
        children: [
          const Text(
            'Витрати за категоріями',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final bucket in categoryBuckets)
                  ChartBar(
                    fill: maxTotalCategoryExpense == 0
                        ? 0
                        : bucket.totalExpenses / maxTotalCategoryExpense,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: categoryBuckets
                .map(
                  (bucket) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        categoryIcons[bucket.category],
                        color: isDarkMode
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).colorScheme.primary.withOpacity(0.7),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 24),
          const Text(
            'Витрати за членами сім\'ї',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final bucket in familyMemberBuckets)
                  ChartBar(
                    fill: maxTotalFamilyMemberExpense == 0
                        ? 0
                        : bucket.totalExpenses / maxTotalFamilyMemberExpense,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: familyMemberBuckets
                .map(
                  (bucket) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        bucket.familyMember.name.substring(0, 1).toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isDarkMode
                              ? Theme.of(context).colorScheme.secondary
                              : Theme.of(context).colorScheme.primary.withOpacity(0.7),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
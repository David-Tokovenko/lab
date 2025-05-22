import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key, required this.expenses});

  final List<Expense> expenses;

  Map<FamilyMember, double> get totalExpensesByFamilyMember {
    final totals = <FamilyMember, double>{};
    for (final member in FamilyMember.values) {
      totals[member] = expenses
          .where((expense) => expense.familyMember == member)
          .fold(0.0, (sum, expense) => sum + expense.amount);
    }
    return totals;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Статистика витрат'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Загальні витрати за членами сім\'ї:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            for (var entry in totalExpensesByFamilyMember.entries)
              Text(
                  '${entry.key.name.toUpperCase()}: \$${entry.value.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
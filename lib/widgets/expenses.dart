import 'package:flutter/material.dart'; // Імпорт основної бібліотеки віджетів Flutter
import 'package:expense_tracker/widgets/new_expense.dart'; // Імпорт файлу з віджетом для додавання нової витрати

import 'package:expense_tracker/models/expense.dart'; // Імпорт файлу з моделлю даних витрати
import 'package:expense_tracker/widgets/chart/chart.dart'; // Імпорт файлу з віджетом для відображення графіка витрат
import 'package:expense_tracker/widgets/statistics_screen.dart';

// Віджет Expenses є StatefulWidget, оскільки його стан (список витрат) може змінюватися
class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState(); // Створення стану для віджета Expenses
  }
}

// Клас _ExpensesState представляє стан віджета Expenses
class _ExpensesState extends State<Expenses> {
  // Приватний список для зберігання зареєстрованих витрат
  final List<Expense> _registeredExpenses = [
    Expense(
      title: 'Flutter Course', // Назва витрати
      amount: 19.99, // Сума витрати
      date: DateTime.now(), // Дата витрати (поточна дата)
      category: Category.work, // Категорія витрати (робота)
      familyMember: FamilyMember.father,
    ),
    Expense(
      title: 'Cinema', // Назва витрати
      amount: 15.69, // Сума витрати
      date: DateTime.now(), // Дата витрати (поточна дата)
      category: Category.leisure, // Категорія витрати (дозвілля)
      familyMember: FamilyMember.son,
    ),
    Expense(
      title: 'Groceries', // Назва витрати
      amount: 55.00, // Сума витрати
      date: DateTime.now(), // Дата витрати (поточна дата)
      category: Category.food, // Категорія витрати (їжа)
      familyMember: FamilyMember.mother,
    ),
    Expense(
      title: 'New Game', // Назва витрати
      amount: 49.99, // Сума витрати
      date: DateTime.now().subtract(const Duration(days: 2)),
      category: Category.entertainment, // Категорія витрати (розваги)
      familyMember: FamilyMember.son,
    ),
  ];

  final List<Category> _selectedCategories = Category.values.toList();
  FamilyMember? _selectedFamilyMember;

  // Метод для відкриття модального вікна додавання нової витрати
  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      isScrollControlled: true, // Дозволяє модальному вікну займати більше половини екрана
      context: context, // Контекст поточного віджета
      builder: (ctx) => NewExpense(onAddExpense: _addExpense), // Побудова вмісту модального вікна за допомогою віджета NewExpense та передача функції _addExpense
    );
  }

  void _toggleCategoryFilter(Category category, bool isSelected) {
    setState(() {
      if (isSelected) {
        if (!_selectedCategories.contains(category)) {
          _selectedCategories.add(category);
        }
      } else {
        _selectedCategories.remove(category);
      }
    });
  }

  void _selectFamilyMemberFilter(FamilyMember? member) {
    setState(() {
      _selectedFamilyMember = member;
    });
  }

  // Метод для додавання нової витрати до списку
  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense); // Додавання витрати до списку
    }); // Виклик setState для оновлення UI
  }

  // Метод для видалення витрати зі списку
  List<Expense> get _filteredExpenses {
    return _registeredExpenses.where((expense) {
      final isCategorySelected = _selectedCategories.contains(expense.category);
      final isFamilyMemberSelected = _selectedFamilyMember == null ||
          expense.familyMember == _selectedFamilyMember;
      return isCategorySelected && isFamilyMemberSelected;
    }).toList();
  }

  void _openStatisticsScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => StatisticsScreen(expenses: _filteredExpenses),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    
    



    return Scaffold(
      appBar: AppBar(
        title: const Text('Трекер витрат'), // Заголовок AppBar
        actions: [
          IconButton(
            onPressed: _openStatisticsScreen,
            icon: const Icon(Icons.assessment), // Додана іконка статистики
          ),
          IconButton(
            onPressed: _openAddExpenseOverlay, // Виклик методу для відкриття модального вікна при натисканні
            icon: const Icon(Icons.add), // Іконка кнопки додавання
          ),
        ],
      ),
      body: width < 600
          ? Column(
              children: [
                Chart(expenses: _filteredExpenses), // Відображення графіка витрат
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    spacing: 8.0,
                    children: Category.values.map((category) {
                      return FilterChip(
                        label: Text(category.name.toUpperCase()),
                        selected: _selectedCategories.contains(category),
                        onSelected: (isSelected) {
                          _toggleCategoryFilter(category, isSelected);
                        },
                      );
                    }).toList(),
                  ),
                ),
                DropdownButton<FamilyMember>(
                  value: _selectedFamilyMember,
                  hint: const Text('Фільтр за сім\'єю'),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('Всі члени сім\'ї'),
                    ),
                    ...FamilyMember.values.map((member) {
                      return DropdownMenuItem(
                        value: member,
                        child: Text(member.name.toUpperCase()),
                      );
                    }).toList(),
                  ],
                  onChanged: _selectFamilyMemberFilter,
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: Chart(expenses: _filteredExpenses),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Wrap(
                          spacing: 8.0,
                          children: Category.values.map((category) {
                            return FilterChip(
                              label: Text(category.name.toUpperCase()),
                              selected: _selectedCategories.contains(category),
                              onSelected: (isSelected) {
                                _toggleCategoryFilter(category, isSelected);
                              },
                            );
                          }).toList(),
                        ),
                      ),
                      DropdownButton<FamilyMember>(
                        value: _selectedFamilyMember,
                        hint: const Text('Фільтр за сім\'єю'),
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text('Всі члени сім\'ї'),
                          ),
                          ...FamilyMember.values.map((member) {
                            return DropdownMenuItem(
                              value: member,
                              child: Text(member.name.toUpperCase()),
                            );
                          }).toList(),
                        ],
                        onChanged: _selectFamilyMemberFilter,
                      ),
                     
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
import 'package:flutter/material.dart'; // Імпорт основної бібліотеки віджетів Flutter
import 'package:expense_tracker/models/expense.dart'; // Імпорт файлу з моделлю даних витрати

// Віджет NewExpense є StatefulWidget, оскільки його стан (введені дані) може змінюватися
class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;
  // Функція зворотного виклику, яка викликається при додаванні нової витрати

  @override
  State<NewExpense> createState() {
    return _NewExpenseState(); // Створення стану для віджета NewExpense
  }
}

// Клас _NewExpenseState представляє стан віджета NewExpense
class _NewExpenseState extends State<NewExpense> {
  final _titleController =
      TextEditingController(); // Контролер для поля введення назви витрати
  final _amountController =
      TextEditingController(); // Контролер для поля введення суми витрати
  DateTime?
  _selectedDate; // Змінна для зберігання обраної дати (може бути null)
  Category _selectedCategory =
      Category
          .leisure; // Змінна для зберігання обраної категорії витрати (за замовчуванням - дозвілля)
  FamilyMember _selectedFamilyMember =
      FamilyMember
          .father; // Змінна для зберігання обраного члена сім'ї (за замовчуванням - батько)

  // Метод для відображення вікна вибору дати
  void _presentDatePicker() async {
    final now = DateTime.now(); // Отримання поточної дати та часу
    final firstDate = DateTime(
      now.year - 1,
      now.month,
      now.day,
    ); // Визначення найранішої доступної дати (рік тому)
    final pickedDate = await showDatePicker(
      context: context, // Контекст поточного віджета
      initialDate: now, // Початкова дата, яка буде відображена у вікні вибору
      firstDate: firstDate, // Найраніша дата, яку можна вибрати
      lastDate: now, // Найпізніша дата, яку можна вибрати
    );
    setState(() {
      _selectedDate = pickedDate; // Оновлення обраної дати та перемалювання UI
    });
  }

  // Метод для обробки відправки даних про витрату
  void _submitExpenseData() {
    final enteredTitle = _titleController.text.trim();
    final enteredAmount = double.tryParse(
      _amountController
          .text, // Спроба перетворити введений текст у число з плаваючою комою
    ); // tryParse('Hello') => null, tryParse('1.12') => 1.12
    final amountIsInvalid =
        enteredAmount == null ||
        enteredAmount <= 0; // Перевірка, чи введена сума є недійсною

    if (enteredTitle.isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Некоректне введення'),
          content: const Text('Будь ласка, введіть назву витрати.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    if (amountIsInvalid) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Некоректне введення'),
          content: const Text('Будь ласка, введіть коректну суму витрати (більше 0).'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    if (_selectedDate == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Некоректне введення'),
          content: const Text('Будь ласка, виберіть дату витрати.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    widget.onAddExpense(
      // Виклик функції зворотного виклику для додавання нової витрати
      Expense(
        title: enteredTitle, // Отримання назви з контролера
        amount: enteredAmount, // Отримання суми (вже перевірено на null)
        date: _selectedDate!, // Отримання обраної дати (вже перевірено на null)
        category: _selectedCategory, // Отримання обраної категорії
        familyMember:
            _selectedFamilyMember, // Отримання обраного члена сім'ї
      ),
    );
    Navigator.pop(context); // Закриття модального вікна після додавання витрати
  }

  @override
  void dispose() {
    // Метод, який викликається при видаленні віджета з дерева віджетів
    _titleController.dispose(); // Звільнення ресурсів контролера назви
    _amountController.dispose(); // Звільнення ресурсів контролера суми
    super.dispose(); // Виклик методу dispose батьківського класу
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        48,
        16,
        16,
      ), // Встановлення відступів навколо вмісту
      child: Column(
        children: [
          TextField(
            controller:
                _titleController, // Прив'язка контролера до текстового поля
            maxLength: 50, // Максимальна довжина введеного тексту
            decoration: const InputDecoration(
              label: Text('Назва'),
            ), // Оформлення текстового поля (мітка "Title")
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller:
                      _amountController, // Прив'язка контролера до текстового поля
                  keyboardType:
                      TextInputType
                          .numberWithOptions(decimal: true), // Вказівка на використання числової клавіатури з можливістю введення десяткових знаків
                  decoration: const InputDecoration(
                    prefixText: '\$ ', // Префікс для суми (знак долара)
                    label: Text(
                      'Сума',
                    ), // Оформлення текстового поля (мітка "Amount")
                  ),
                ),
              ),
              const SizedBox(
                width: 16,
              ), // Додавання горизонтального відступу між полями
              Expanded(
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .end, // Вирівнювання вмісту по правому краю
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .center, // Вирівнювання вмісту по центру вертикалі
                  children: [
                    Text(
                      _selectedDate == null
                          ? 'Не обрано дату' // Відображення цього тексту, якщо дата не обрана
                          : formatter.format(
                            _selectedDate!,
                          ), // Форматування та відображення обраної дати
                    ),
                    IconButton(
                      onPressed:
                          _presentDatePicker, // Виклик методу для відображення вікна вибору дати при натисканні
                      icon: const Icon(
                        Icons.calendar_month,
                      ), // Іконка календаря
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16), // Додавання вертикального відступу
          Row(
            children: [
              DropdownButton(
                value:
                    _selectedCategory, // Поточне обране значення випадаючого списку
                items:
                    Category
                        .values // Отримання всіх значень з enum Category
                        .map(
                          (category) => DropdownMenuItem(
                            value:
                                category, // Значення елемента випадаючого списку
                            child: Text(
                              category.name.toUpperCase(),
                            ), // Відображення назви категорії у верхньому регістрі
                          ),
                        )
                        .toList(), // Перетворення відображених елементів на список
                onChanged: (value) {
                  // Обробник зміни обраного значення
                  if (value == null) {
                    return; // Вихід, якщо значення null
                  }
                  setState(() {
                    _selectedCategory =
                        value; // Оновлення обраної категорії та перемалювання UI
                  });
                },
              ),
              const SizedBox(width: 24),
              DropdownButton(
                value:
                    _selectedFamilyMember, // Поточне обране значення випадаючого списку для члена сім'ї
                items:
                    FamilyMember
                        .values // Отримання всіх значень з enum FamilyMember
                        .map(
                          (member) => DropdownMenuItem(
                            value:
                                member, // Значення елемента випадаючого списку
                            child: Text(
                              member.name.toUpperCase(),
                            ), // Відображення імені члена сім'ї у верхньому регістрі
                          ),
                        )
                        .toList(), // Перетворення відображених елементів на список
                onChanged: (value) {
                  // Обробник зміни обраного значення
                  if (value == null) {
                    return; // Вихід, якщо значення null
                  }
                  setState(() {
                    _selectedFamilyMember =
                        value; // Оновлення обраного члена сім'ї та перемалювання UI
                  });
                },
              ),
              const Spacer(), // Займає все доступне місце між елементами
              TextButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                  ); // Закриття модального вікна при натисканні кнопки "Cancel"
                },
                child: const Text('Скасувати'), // Текст кнопки "Cancel"
              ),
              ElevatedButton(
                onPressed:
                    _submitExpenseData, // Виклик методу для відправки даних при натисканні кнопки "Save Expense"
                child: const Text(
                  'Зберегти витрату',
                ), // Текст кнопки "Save Expense"
              ),
            ],
          ),
        ],
      ),
    );
  }
}
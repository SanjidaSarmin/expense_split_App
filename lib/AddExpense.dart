import 'package:expense_splitter/service/ExpenseService.dart';
import 'package:flutter/material.dart';

class AddExpensePage extends StatefulWidget {
  final int groupId;
  final List<Map<String, dynamic>> groupMembers;

  AddExpensePage({required this.groupId, required this.groupMembers});

  @override
  _AddExpensePageState createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final _descController = TextEditingController();
  final _amountController = TextEditingController();
  int? _paidBy;
  final List<Map<String, dynamic>> _splits = [];

  void _submitExpense() async {
    if (_paidBy == null || _splits.isEmpty) return;

    // Prepare the expense data as a Map instead of using models
    final expenseData = {
      'groupId': widget.groupId.toString(),
      'description': _descController.text,
      'totalAmount': double.parse(_amountController.text),
      'paidBy': _paidBy,
      'splits': _splits,
    };

    // Call the service to create expense
    final success = await ExpenseService().createExpense(expenseData);
    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Expense added")));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Expense")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _descController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: 'Total Amount'),
              keyboardType: TextInputType.number,
            ),

            DropdownButtonFormField<int>(
              decoration: InputDecoration(labelText: "Paid By"),
              value: _paidBy,
              items:
                  widget.groupMembers.map<DropdownMenuItem<int>>((member) {
                    return DropdownMenuItem<int>(
                      value: member['id'] as int,
                      child: Text(member['name']),
                    );
                  }).toList(),
              onChanged: (value) => setState(() => _paidBy = value),
            ),

            const SizedBox(height: 20),
            Text(
              "Split Amounts",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            ...widget.groupMembers.map((member) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(member['name']),
                  SizedBox(
                    width: 100,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        final amount = double.tryParse(value) ?? 0.0;
                        _splits.removeWhere(
                          (s) => s['memberId'] == member['id'],
                        );
                        if (amount > 0) {
                          _splits.add({
                            'memberId': member['id'],
                            'amountOwed': amount,
                          });
                        }
                      },
                    ),
                  ),
                ],
              );
            }),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitExpense,
              child: Text("Save Expense"),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:expense_splitter/Group.dart';

class CreateListPage extends StatefulWidget {
  final String groupName;
  final String currency;

     const CreateListPage({
    Key? key,
    this.groupName = 'My Group',
    this.currency = 'USD',
  }) : super(key: key);
  @override
  _CreateListPageState createState() => _CreateListPageState();
}

class _CreateListPageState extends State<CreateListPage> {
  final TextEditingController _listNameController = TextEditingController();
  String _selectedCurrency = 'USD';

  final List<String> _currencies = ['USD', 'BDT','EUR', 'INR', 'GBP', 'JPY'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: TextStyle(color: Colors.white)),
        ),
      ),
     body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "Create list",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 24),

            // Continue with list name field, currency, etc.
            TextField(
              controller: _listNameController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'List name',
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.grey.shade900,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: _selectedCurrency,
              dropdownColor: Colors.grey.shade900,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade900,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                labelText: 'Currency',
                labelStyle: TextStyle(color: Colors.white),
              ),
              items: _currencies.map((currency) {
                return DropdownMenuItem(
                  value: currency,
                  child: Text(currency),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCurrency = value!;
                });
              },
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Currency of shown balance and settlements.',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            Spacer(),
           ElevatedButton(
              onPressed: () {
                if (_listNameController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter a list name'),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else {
                  // ✅ Pass group name and currency
                   Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateListMembersPage(
                        groupName: _listNameController.text.trim(),
                        currency: _selectedCurrency,
                      ),
                    ),
                  );
                }
              },
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.blue,
    minimumSize: Size(double.infinity, 50),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  child: Text('Next', style: TextStyle(fontSize: 16)),
),

          ],
        ),
      ),
    );
  }
}
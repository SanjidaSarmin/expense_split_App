import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewExpensePage extends StatefulWidget {
  final String groupId;

  const NewExpensePage({super.key, required this.groupId});

  @override
  _NewExpensePageState createState() => _NewExpensePageState();
}

class _NewExpensePageState extends State<NewExpensePage> {
  String selectedType = "Expense";
  DateTime selectedDate = DateTime.now();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  int? selectedPayerId;

  String groupName = "Loading...";
  String currency = '';
  List<dynamic> groupMembers = [];

  Map<String, double> memberShares = {};

  @override
  void initState() {
    super.initState();
    fetchGroupDetails();
  }

  Future<void> fetchGroupDetails() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.0.106:8082/api/groups/${widget.groupId}'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        print("Response Body: ${response.body}");

        setState(() {
          groupName = data['name'] ?? 'Group';
          groupMembers = data['members'] ?? [];
          currency = data['currency'] ?? '';
        });
      } else {
        print("Failed to load group details");
      }
    } catch (e) {
      print("Error fetching group details: $e");
    }
  }

  Future<void> submitExpense() async {
    final description = descriptionController.text;
    final totalAmount = double.tryParse(amountController.text);

    if (widget.groupId == null) {
      print("❌ Error: groupId is null");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Group ID is missing. Cannot submit expense.")),
      );
      return;
    }
    if (totalAmount == null || totalAmount <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please enter a valid amount.")));
      return;
    }

    if (selectedPayerId == null) {
      print("❌ Error: selectedPayerId is null");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select who paid the amount.")),
      );
      return;
    }

    final splits =
        memberShares.entries.map((entry) {
          final memberId = int.tryParse(entry.key);
          if (memberId == null) {
            print("❌ Error: Invalid member ID in shares.");
          }
          return {'memberId': memberId, 'amountOwed': entry.value};
        }).toList();

    for (var split in splits) {
      if (split['memberId'] == null) {
        print("❌ Error: A memberId in splits is null");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("A member ID is missing in the split.")),
        );
        return;
      }
    }

    final expenseRequest = {
      'groupId': widget.groupId,
      'description': description,
      'totalAmount': totalAmount,
      'paidBy': selectedPayerId,
      'splits': splits,
    };

    print("🔸 Expense Request Payload:");
    print("Group ID: ${expenseRequest['groupId']}");
    print("Description: ${expenseRequest['description']}");
    print("Total Amount: ${expenseRequest['totalAmount']}");
    print("Paid By: ${expenseRequest['paidBy']}");
    print("Splits:");
    for (var split in splits) {
      print(
        " - Member ID: ${split['memberId']}, Amount Owed: ${split['amountOwed']}",
      );
    }

    final response = await http.post(
      Uri.parse('http://192.168.0.106:8082/api/expenses'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(expenseRequest),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Expense added successfully.")));
      Navigator.pop(context);
    } else {
      print('❌ Failed to add expense. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add expense. Please try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Cancel", style: TextStyle(color: Colors.white)),
        ),
        title: Text(groupName, style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              submitExpense();
            },

            child: Text("Save", style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ToggleButtons(
              fillColor: Colors.grey[800],
              borderRadius: BorderRadius.circular(10),
              isSelected: [
                selectedType == "Expense",
                selectedType == "Income",
                selectedType == "Transfer",
              ],
              onPressed: (index) {
                setState(() {
                  selectedType = ["Expense", "Income", "Transfer"][index];
                });
              },
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text("Expense", style: TextStyle(color: Colors.white)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text("Income", style: TextStyle(color: Colors.white)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Transfer",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            TextField(
              controller: descriptionController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Description',
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[900],
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.receipt_long, color: Colors.grey),
                    IconButton(
                      icon: Icon(Icons.camera_alt, color: Colors.grey),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: amountController,
              style: TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '\ 0.00',
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[900],
                suffix: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  color: Colors.grey[850],
                  child: Text(
                    currency, // use the dynamic value here
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.pink,
                  child: Text(
                    "SS", // Replace this with dynamic initials
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(width: 10),
                // Member's name (Dynamic name of the current user)
                Text(
                  "You", // Replace with dynamic name from groupMembers
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(width: 20),
                // Dropdown to select payer
                DropdownButton<int>(
                  value: selectedPayerId,
                  hint: Text(
                    "Select Payer",
                    style: TextStyle(color: Colors.white),
                  ),
                  dropdownColor:
                      Colors.pink, // Optional: To make dropdown background pink
                  style: TextStyle(color: Colors.white),
                  onChanged: (int? newValue) {
                    setState(() {
                      selectedPayerId = newValue; // Update selected payer ID
                    });
                  },
                  items:
                      groupMembers.map<DropdownMenuItem<int>>((member) {
                        return DropdownMenuItem<int>(
                          value: member['id'], // Using member ID
                          child: Text(
                            member['name'],
                            style: TextStyle(color: Colors.white),
                          ), // Member name
                        );
                      }).toList(),
                ),
                Spacer(),
                TextButton(
                  onPressed: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      setState(() {
                        selectedDate = picked;
                      });
                    }
                  },
                  child: Text(
                    "${selectedDate.month}/${selectedDate.day}/${selectedDate.year}",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                DropdownButton<String>(
                  dropdownColor: Colors.grey[900],
                  value: "Shares",
                  items:
                      ["Shares"].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Row(
                            children: [
                              Icon(
                                Icons.pie_chart_outline,
                                color: Colors.white,
                              ),
                              SizedBox(width: 10),
                              Text(
                                value,
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                  onChanged: (_) {},
                ),
                Spacer(),
                Icon(Icons.people, color: Colors.blue),
                SizedBox(width: 10),
                // Text("Split equally", style: TextStyle(color: Colors.blue)),
                GestureDetector(
                  onTap: () {
                    double totalAmount =
                        double.tryParse(amountController.text) ?? 0.0;
                    int numMembers = groupMembers.length;

                    if (numMembers > 0 && totalAmount > 0) {
                      double splitAmount = totalAmount / numMembers;

                      setState(() {
                        memberShares.clear(); // Clear any old values
                        for (var member in groupMembers) {
                          int memberId = member['id'];
                          member['share'] = splitAmount;
                          memberShares[memberId.toString()] =
                              splitAmount; // 🔥 This is the fix
                        }
                      });
                    }
                  },

                  child: Text(
                    "Split Equally",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),
            // Display Split Amount for each member
            ...groupMembers.map<Widget>((member) {
              final name = member['name'] ?? 'Unknown';
              final share = member['share'] ?? 0.0;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Text(name, style: TextStyle(color: Colors.white)),
                    Spacer(),
                    Container(
                      width: 50,
                      padding: EdgeInsets.all(8),
                      color: Colors.grey[900],
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: 70,
                      padding: EdgeInsets.all(8),
                      color: Colors.grey[900],
                      child: Text(
                        "${share.toStringAsFixed(2)}",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

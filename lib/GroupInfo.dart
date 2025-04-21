import 'dart:convert';

import 'package:expense_splitter/AddExpense.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GroupDetailsPage extends StatefulWidget {
  final String groupId;

  const GroupDetailsPage({Key? key, required this.groupId}) : super(key: key);

  @override
  _GroupDetailsPageState createState() => _GroupDetailsPageState();
}

class _GroupDetailsPageState extends State<GroupDetailsPage> {
  late String groupName; // Initialize the group name here
  late String initials; // Initialize initials if needed
  List<dynamic> groupMembers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchGroupDetails();
  }

  // Fetch group details from the API using groupId
  Future<void> fetchGroupDetails() async {
    try {
      final response = await http.get(
        Uri.parse(
          "http://192.168.0.106:8082/api/groups/${widget.groupId}",
        ), // Fetch group by ID
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          // Ensure groupName is a String, if it's an int, cast it to a string
          groupName =
              data['name']?.toString() ??
              'Unknown Group'; // Safely convert to String
          initials =
              groupName.isNotEmpty
                  ? groupName
                      .split(' ')
                      .map((e) => e[0])
                      .take(2)
                      .join() // Get initials
                  : 'AB'; // Default initials if groupName is empty or not found
          groupMembers = data['members'] ?? []; // Fetch members
          isLoading = false;
        });
      } else {
        print("Failed to load group details");
      }
    } catch (e) {
      print("Error fetching group details: $e");
    }
  }

  Future<List<dynamic>> fetchExpensesByGroup(String groupId) async {
    final url = 'http://192.168.0.106:8082/api/expenses/$groupId';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final expenses = jsonDecode(response.body);
      print('Fetched expenses: $expenses'); // Debug print
      return expenses;
    } else {
      throw Exception('Failed to load expenses');
    }
  }

  List<Widget> calculateBalanceWidgets(List<dynamic> expenses) {
    List<Widget> widgets = [];

    // Loop over each expense to display required information
    for (var expense in expenses) {
      String description = expense['description'] ?? 'No Description';
      String paidBy = expense['paidBy']['name'] ?? 'Unknown';
      double totalAmount = (expense['totalAmount'] ?? 0.0).toDouble();
      List members = expense['group']['members'] ?? [];

      // Add custom design widget
      widgets.add(
        Card(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Description section
                Text(
                  'Description: $description',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(221, 255, 255, 255),
                  ),
                ),
                SizedBox(height: 8),

                // Total amount section
                Text(
                  'Total Amount: ${totalAmount.toStringAsFixed(2)} BDT',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                SizedBox(height: 12),

                // Members section - show who owes and how much
                Text(
                  'Members details:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(221, 247, 244, 244),
                  ),
                ),
                SizedBox(height: 8),

                // Loop through each member and display their details
                for (var member in members)
                  Builder(
                    builder: (context) {
                      // Find the share for this member (if any)
                      var share = (expense['shares'] as List).firstWhere(
                        (s) => s['member']['name'] == member['name'],
                        orElse: () => null,
                      );

                      double amountOwed =
                          (share != null
                              ? (share['amountOwed'] ?? 0.0).toDouble()
                              : 0.0);

                      return Text(
                        '${member['name']} owes: ${amountOwed.toStringAsFixed(2)} BDT',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromARGB(137, 255, 254, 254),
                        ),
                      );
                    },
                  ),

                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.money, color: Colors.green),
                    Text(
                      'Paid: $paidBy',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: PreferredSize(
  preferredSize: Size.fromHeight(170),
  child: SafeArea(
    child: Column(
      mainAxisSize: MainAxisSize.min, // 👈 Add this
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Spacer(),
              Icon(Icons.settings, color: Colors.white),
            ],
          ),
        ),
        Row(
          children: [
            SizedBox(width: 16),
            Stack(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.check,
                      color: Colors.deepOrangeAccent,
                      size: 40,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: Icon(
                    Icons.camera_alt,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(width: 16),
            isLoading
                ? CircularProgressIndicator()
                : Text(
                    groupName,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            SizedBox(width: 10),
            CircleAvatar(
              radius: 14,
              backgroundColor: Colors.pink,
              child: Text(
                initials,
                style: TextStyle(fontSize: 10, color: Colors.white),
              ),
            ),
          ],
        ),
        
    Container(
  height: 40, // Set a fixed height to control spacing
  child: TabBar(
    indicatorColor: Colors.deepOrangeAccent,
    padding: EdgeInsets.zero, 
    labelPadding: EdgeInsets.zero, 
    tabs: [
      Tab(text: 'Transactions'),
      Tab(text: 'Balance'),
      Tab(text: 'Settlements'),
    ],
  ),
),


      ],
    ),
  ),
),

        body: TabBarView(
          children: [
            // Transactions Tab
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'There are no expenses yet.',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Text(
                    'Start with adding some expenses.',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            // Balance Tab
            FutureBuilder<List<dynamic>>(
              future: fetchExpensesByGroup(widget.groupId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error loading balances',
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                } else {
                  final expenses = snapshot.data!;
                  return ListView(children: calculateBalanceWidgets(expenses));
                }
              },
            ),

            // Settlements Tab
            Center(
              child: Text(
                'Settlements Tab',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        floatingActionButton: Builder(
          builder: (context) {
            // Show Floating Action Button only for Transactions tab (index 0)
            if (DefaultTabController.of(context)?.index == 0) {
              return FloatingActionButton(
                onPressed: () {
                  print('Sending groupId: ${widget.groupId}');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => NewExpensePage(groupId: widget.groupId),
                    ),
                  );
                },

                backgroundColor: Colors.blue,
                child: Icon(Icons.add),
              );
            }
            return SizedBox.shrink(); // Return an empty widget if not on the Transactions tab
          },
        ),
      ),
    );
  }
}

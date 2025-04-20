import 'package:expense_splitter/AddExpense.dart';
import 'package:flutter/material.dart';


class Groupinfo extends StatelessWidget {
   final Map<String, dynamic> group;

  const Groupinfo({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense App',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.black,
        tabBarTheme: TabBarTheme(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
        ),
      ),
      home: GroupDetailsPage(group: group),
      debugShowCheckedModeBanner: false,
    );
  }
}

class GroupDetailsPage extends StatefulWidget {
  final Map<String, dynamic> group;

  const GroupDetailsPage({super.key, required this.group});
  
  @override
  _GroupDetailsPageState createState() => _GroupDetailsPageState();
}

class _GroupDetailsPageState extends State<GroupDetailsPage> {
   late String groupName;
  late String initials;

  late int groupId;
late List<Map<String, dynamic>> groupMembers;

  @override
  void initState() {
    super.initState();
    groupName = widget.group['name'] ?? 'Unnamed';
    initials = _getInitials(widget.group['name']);

    
  }

  String _getInitials(String? name) {
    if (name == null || name.isEmpty) return 'NA';
    List<String> parts = name.split(' ');
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return parts[0][0].toUpperCase() + parts[1][0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(170),
          child: Column(
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.arrow_back, color: Colors.white),
                      Spacer(),
                      Icon(Icons.settings, color: Colors.white),
                    ],
                  ),
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
                          child: Icon(Icons.check, color: Colors.deepOrangeAccent, size: 40),
                        ),
                      ),
                      Positioned(
                        bottom: 2,
                        right: 2,
                        child: Icon(Icons.camera_alt, size: 18, color: Colors.white),
                      )
                    ],
                  ),
                  SizedBox(width: 16),
                  Text(
                    groupName,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 10),
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.pink,
                    child: Text(initials, style: TextStyle(fontSize: 10, color: Colors.white)),
                  )
                ],
              ),
              SizedBox(height: 10),
               TabBar(
                indicatorColor: Colors.deepOrangeAccent,
                tabs: [
                  Tab(text: 'Transactions'),
                  Tab(text: 'Balance'),
                  Tab(text: 'Settlements'),
                ],
              ),
            ],
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
            Center(child: Text('Balance Tab', style: TextStyle(color: Colors.white))),
            // Settlements Tab
            Center(child: Text('Settlements Tab', style: TextStyle(color: Colors.white))),
          ],
        ),
        floatingActionButton: Builder(
          builder: (context) {
            // Show Floating Action Button only for Transactions tab (index 0)
            if (DefaultTabController.of(context)?.index == 0) {
              return FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddExpensePage(
                        groupId: groupId,  // Pass the groupId dynamically here
                        groupMembers: groupMembers,
                      ),
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

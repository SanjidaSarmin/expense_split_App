import 'package:expense_splitter/Friend.dart';
import 'package:expense_splitter/GroupInfo.dart';
import 'package:expense_splitter/HomePage.dart';
import 'package:expense_splitter/Profile.dart';
import 'package:expense_splitter/service/GroupService.dart';
import 'package:flutter/material.dart';

class Viewlist extends StatelessWidget {
  const Viewlist({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Lists',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1B1E1F),
        primaryColor: Colors.blue,
        useMaterial3: true,
      ),
      home: const ListScreen(),
    );
  }
}

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final GroupService _groupService = GroupService();

  List<Map<String, dynamic>> _groups = [];

  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeTab(), // Updated tab with image & button
    ListScreen(),
    FriendTab(),
    ProfileTab(),
  ];

  void _onItemTapped(int index) {
    if (index == 0) {
      // Navigate to profile screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else if (index == 1) {
      // Navigate to profile screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Viewlist()),
      );
    } else if (index == 2) {
      // Navigate to profile screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FriendsPage()),
      );
    } else if (index == 3) {
      // Navigate to profile screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  // Fetch groups from the API
  @override
  void initState() {
    super.initState();
    _fetchGroups(); // Call the fetch groups method when screen loads
  }

  Future<void> _fetchGroups() async {
    try {
      final fetchedGroups = await _groupService.fetchGroups();
      setState(() {
        _groups = fetchedGroups;
        print(_groups);
      });
    } catch (e) {
      print('Error fetching groups: $e');
    }
  }

  // Show delete confirmation dialog
  void _showDeleteDialog(int groupId) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Delete List'),
            content: const Text('Are you sure you want to delete this list?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(ctx).pop(); // Close dialog first
                  bool deleted = await _groupService.deleteGroup(groupId);
                  if (deleted) {
                    setState(() {
                      _groups.removeWhere((group) => group['id'] == groupId);
                    });
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Group deleted')));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to delete group')),
                    );
                  }
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  void _deleteGroup(int groupId) async {
    bool success = await _groupService.deleteGroup(groupId);

    if (success) {
      setState(() {
        _groups.removeWhere(
          (group) => group['id'] == groupId,
        ); // Use correct key
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Group deleted')));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to delete group')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Lists",
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, size: 28, color: Colors.white),
            onPressed: () {
              showSearch(
                context: context,
                delegate: GroupSearchDelegate(
                  _groups, // Pass the list of groups to the search delegate
                  onDelete: _deleteGroup, // Pass the delete function for items
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.person_add_alt_1,
              size: 32,
              color: Colors.blue,
            ),
            onPressed: () {
              setState(() {
                _groups.add({'name': 'New List', 'balance': '\$0.00'});
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child:
            _groups.isEmpty
                ? const Center(
                  child: CircularProgressIndicator(),
                ) // Show loading indicator while fetching data
                : Column(
                  children: [
                    ..._groups.asMap().entries.map((entry) {
                      final index = entry.key;
                      final group = entry.value;
                      final groupId = group['id'];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ListTileCard(
                          name: group['name'] ?? 'No Name',
                          balance: group['currency'] ?? 'No Balance',
                          subtitle:
                              group['members'] is List
                                  ? (group['members'] as List)
                                      .map((m) => m['name'])
                                      .join(', ')
                                  : '${group['members']} member(s)', // If no members, show 'No Members'

                          onTap: () {
                           print("------ ${group['id']}");
                            print("------ ${group['name']}");
                            print("MEMBERS TYPE: ${group['members'].runtimeType}");
                            print("MEMBERS VALUE: ${group['members']}");

                            
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => GroupDetailsPage(groupId: groupId.toString()),
                              ),
                            );
                          },
                          onLongPress: () {
                            _showDeleteDialog(
                              group['id'],
                            ); // Make sure to use group ID
                          },
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2A2F4F),
                        minimumSize: const Size(double.infinity, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        // Handle add new list
                      },
                      child: const Text(
                        "Add new list",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Color(0xFF1C8D5E), // green shade
        unselectedItemColor: Colors.white70,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w500),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w400),
        iconSize: 26,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_rounded,
            ), // can be Icons.insert_chart_alt_rounded
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_list_rounded),
            label: 'List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add_alt),
            label: 'Friends',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle_outlined,
            ), // or use Image.asset if custom
            label: 'Account',
          ),
        ],
      ),
    );
  }
}

// Show delete confirmation dialog
class ListTileCard extends StatelessWidget {
  final String name;
  final String balance;
  final String subtitle;
  final VoidCallback onLongPress;
  final VoidCallback onTap;

  const ListTileCard({
    super.key,
    required this.name,
    required this.balance,
    required this.subtitle,
    required this.onLongPress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2A2F4F),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1B1E1F),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8),
              child: const Icon(Icons.check, color: Colors.orange, size: 32),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "My balance: $balance",
                  style: const TextStyle(fontSize: 14, color: Colors.white70),
                ),
                Text(
                  "Member: $subtitle",
                  style: const TextStyle(fontSize: 12, color: Colors.white60),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class GroupSearchDelegate extends SearchDelegate {
  final List<Map<String, dynamic>> groups;
  final Function(int) onDelete; // Expect a function that accepts an int (index)

  GroupSearchDelegate(this.groups, {required this.onDelete});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); // Close search
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final queryWords = query.toLowerCase().split(' ');

    final results =
        groups.where((group) {
          final name = (group['name'] ?? '').toString().toLowerCase();
          return queryWords.any((word) => name.contains(word));
        }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final group = results[index];
        final groupId = group['id'];

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTileCard(
            name: group['name'] ?? 'No Name',
            balance: group['currency'] ?? 'No Balance',
            subtitle:
                group['members'] is List
                    ? (group['members'] as List)
                        .map((m) => m['name'])
                        .join(', ')
                    : '${group['members']} member(s)',

            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => GroupDetailsPage(groupId: groupId.toString()),
                ),
              );
            },
            onLongPress: () {
              onDelete(index); // Call the passed delete function
            },
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context); // Optional: show live results while typing
  }
}

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text(' Page', style: TextStyle(fontSize: 24)));
  }
}

class FriendTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text(' Page', style: TextStyle(fontSize: 24)));
  }
}

class ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text(' Page', style: TextStyle(fontSize: 24)));
  }
}

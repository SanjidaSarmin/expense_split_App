import 'package:expense_splitter/Addmember.dart';
import 'package:flutter/material.dart';
import 'package:expense_splitter/service/GroupService.dart'; // Import your service for creating a group

class CreateListMembersPage extends StatefulWidget {
  final String groupName;
  const CreateListMembersPage({Key? key, required this.groupName})
    : super(key: key);

  @override
  State<CreateListMembersPage> createState() => _CreateListMembersPageState();
}

class _CreateListMembersPageState extends State<CreateListMembersPage> {
  List<String> newMembers = []; // List of members added
  String groupName =
      'Trip Group'; // You should pass this dynamically based on the group name
  String currency = 'USD'; // Also should be passed from previous page
  Future<void> _navigateAndAddMembers() async {
    final List<String>? result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddMembersPage()),
    );

    // If result is not null and contains members, add them to the list
    if (result != null && result.isNotEmpty) {
      setState(() {
        newMembers.addAll(result); // Add new members to the list
      });
    }
  }

  // Method to create group with members
 Future<void> _createGroup() async {
  print("🟠 _createGroup() called");
  try {
    final response = await GroupService().createGroup(
      groupName,
      currency,
      newMembers,
    );
    print("✅ Group created: $response");

    if (response != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Group created successfully')),
      );
      Navigator.pop(context);
    }
  } catch (e) {
    print("❌ Error: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to create group: $e')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    int memberCount = newMembers.length;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Create list', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: Text(
              'Members ($memberCount)', // Display dynamic member count
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF1B1B1B),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _buildOptionTile(
                  icon: Icons.chat,
                  text: 'Invite via WhatsApp',
                  onTap: () {},
                ),
                _buildOptionTile(
                  icon: Icons.link,
                  text: 'Share list invitation',
                  onTap: () {},
                ),
                _buildOptionTile(
                  icon: Icons.person_add,
                  text: 'Add members',
                  onTap: () async {
                    final result = await Navigator.push<List<String>>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddMembersPage(),
                      ),
                    );
                    if (result != null && result.isNotEmpty) {
                      setState(() {
                        newMembers.addAll(result);
                      });
                    }
                  },
                ),
                const Divider(color: Colors.white10),
                _buildMemberTile(name: 'Sanjida', isYou: true),

                // Newly added members
                for (var name in newMembers) _buildMemberTile(name: name),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  _createGroup(); // Just call the function inside
                },

                child: const Text(
                  'Done',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.indigo[900],
        child: Icon(icon, color: Colors.white),
      ),
      title: Text(text, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }

  Widget _buildMemberTile({required String name, bool isYou = false}) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.pink,
        child: Text(
          name.length >= 2 ? name.substring(0, 2).toUpperCase() : name,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Text(name, style: const TextStyle(color: Colors.white)),
      trailing:
          isYou
              ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'YOU',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              )
              : null,
    );
  }
}

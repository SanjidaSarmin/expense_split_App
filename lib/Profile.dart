import 'package:expense_splitter/Friend.dart';
import 'package:expense_splitter/HomePage.dart';
import 'package:expense_splitter/ViewList.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 3;

  final List<Widget> _pages = [
    HomeTab(),
    GroupTab(),
    FriendTab(),
    ProfilePage(),
  ];

void _onItemTapped(int index) {
  if (index == 0) {
    // Navigate to profile screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }else if (index == 1) {
    // Navigate to profile screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Viewlist()),
    );
  }else if (index == 2) {
    // Navigate to profile screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FriendsPage()),
    );
  }else if (index == 3) {
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

  final Color iconColor = Colors.white70;
  final Color primaryTextColor = Colors.white;
  final Color secondaryTextColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          Icon(Icons.search, color: iconColor),
          SizedBox(width: 15),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.green,
                child: Icon(Icons.person, size: 30, color: Colors.white),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Sun Shine', style: TextStyle(color: primaryTextColor, fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('sunshine443311@gmail.com', style: TextStyle(color: secondaryTextColor)),
                  ],
                ),
              ),
              Icon(Icons.edit, color: iconColor),
            ],
          ),
          SizedBox(height: 20),
          listItem(Icons.qr_code, "Scan code"),
          listItem(Icons.diamond_outlined, "Splitwise Pro"),
          sectionTitle("Preferences"),
          listItem(Icons.email_outlined, "Email settings"),
          listItem(Icons.notifications_none, "Device and push notification settings"),
          listItem(Icons.lock_outline, "Security"),
          sectionTitle("Feedback"),
          listItem(Icons.star_border, "Rate Splitwise"),
          listItem(Icons.help_outline, "Contact Splitwise support"),
          Divider(color: Colors.grey),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.tealAccent),
            title: Text("Log out", style: TextStyle(color: Colors.tealAccent)),
          ),
          SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                Text("Made with ✨ in Providence, RI, USA", style: TextStyle(color: secondaryTextColor)),
                Text("Copyright © 2025 Splitwise, Inc.", style: TextStyle(color: secondaryTextColor)),
                Text("P.S. Bunnies!", style: TextStyle(color: Colors.tealAccent)),
                SizedBox(height: 10),
                Text("Privacy Policy", style: TextStyle(color: Colors.tealAccent)),
                SizedBox(height: 10),
                Text("v25.3.1/833", style: TextStyle(color: secondaryTextColor)),
              ],
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Color(0xFF1C8D5E),
        unselectedItemColor: Colors.white70,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w500),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w400),
        iconSize: 26,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.view_list_rounded), label: 'List'),
          BottomNavigationBarItem(icon: Icon(Icons.person_add_alt), label: 'Friends'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined), label: 'Account'),
        ],
      ),
    );
  }

  Widget listItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title, style: TextStyle(color: primaryTextColor)),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 8),
      child: Text(title.toUpperCase(), style: TextStyle(color: Colors.grey, fontSize: 12)),
    );
  }
}

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text(' Page', style: TextStyle(fontSize: 24)));
  }
}

class GroupTab extends StatelessWidget {
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


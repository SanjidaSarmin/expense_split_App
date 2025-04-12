import 'package:flutter/material.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Track the selected index

  // List of pages for each tab
  final List<Widget> _pages = [
    HomeTab(),
    HistoryTab(),
    ProfileTab(),
    ActivityTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Splitter'),
        backgroundColor: const Color.fromARGB(255, 33, 158, 89),
      ),
      body: _pages[_selectedIndex], // Display the page corresponding to the selected tab
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Friends',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_activity),
            label: 'Activity',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_rounded),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex, // Current selected tab
        selectedItemColor: const Color.fromARGB(255, 28, 141, 94), // Color when selected (green)
        unselectedItemColor: Colors.grey, // Color when not selected
        onTap: _onItemTapped, // Call the function when a tab is tapped
        selectedFontSize: 14, // Font size for selected label
        unselectedFontSize: 12, // Font size for unselected label
        iconSize: 30, // Icon size (larger icons)
      ),
    );
  }
}

// Sample tab for Home
class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.home, size: 100, color: const Color.fromARGB(255, 37, 131, 95)),
          Text('Home Page', style: TextStyle(fontSize: 24)),
        ],
      ),
    );
  }
}

// Sample tab for History
class HistoryTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 100, color: const Color.fromARGB(255, 37, 131, 95)),
          Text('History Page', style: TextStyle(fontSize: 24)),
        ],
      ),
    );
  }
}

// Sample tab for Profile
class ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person, size: 100,  color: const Color.fromARGB(255, 37, 131, 95)),
          Text('Profile Page', style: TextStyle(fontSize: 24)),
        ],
      ),
    );
  }
}

// Sample tab for Activity
class ActivityTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.local_activity, size: 100,  color: const Color.fromARGB(255, 37, 131, 95)),
          Text('Activity Page', style: TextStyle(fontSize: 24)),
        ],
      ),
    );
  }
}
import 'package:expense_splitter/HomePage.dart';
import 'package:expense_splitter/Profile.dart';
import 'package:expense_splitter/ViewList.dart';
import 'package:expense_splitter/service/GroupService.dart';
import 'package:flutter/material.dart';

void main() => runApp(SplitwiseClone());

class SplitwiseClone extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splitwise Clone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: FriendsPage(),
    );
  }
}

class FriendsPage extends StatefulWidget {
  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  List<String> members = [];
  bool isLoading = true;

  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeTab(), // Updated tab with image & button
    GroupTab(),
    FriendsPage(),
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

  @override
  void initState() {
    super.initState();
    loadMembers();
  }

void loadMembers() async {
  setState(() {
    isLoading = true;
  });

  final data = await GroupService().getAllMembers(); // 👈 Updated method
  setState(() {
    members = data.map((member) => member['name'] as String).toList();
    isLoading = false;
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // search action
            },
          ),
          IconButton(
            icon: Icon(Icons.person_add_alt_1),
            onPressed: () {
              // add friend action
            },
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You are all settled up!',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            SizedBox(height: 16),
            // 🧠 Dynamic Member List
            isLoading
                ? Center(child: CircularProgressIndicator())
                : members.isEmpty
                ? Text(
                  'No members found',
                  style: TextStyle(color: Colors.white),
                )
                : Expanded(
                  child: ListView.builder(
                    itemCount: members.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.grey[800],
                              child: Icon(
                                Icons.person,
                                size: 40,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  members[index],
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'no expenses',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

            SizedBox(height: 24),
            Center(
              child: OutlinedButton.icon(
                onPressed: () {
                  // add more friends action
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.greenAccent,
                  side: BorderSide(color: Colors.greenAccent),
                ),
                icon: Icon(Icons.person_add_alt),
                label: Text('Add more friends'),
              ),
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   backgroundColor: Colors.green,
      //   onPressed: () {
      //     // Add expense action
      //   },
      //   icon: Icon(Icons.receipt_long),
      //   label: Text("Add expense"),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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

class GroupTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text(' Page', style: TextStyle(fontSize: 24)));
  }
}

class HomeTab extends StatelessWidget {
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

import 'package:flutter/material.dart';
import 'package:task/models/user_model.dart';
import 'package:task/screens/homeScreen.dart';

class BottomNav extends StatefulWidget {
  final Users user;
  final String userId;
  const BottomNav({super.key, required this.user, required this.userId});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      Homescreen(), // Home screen
      const Center(child: Text('Search Page', style: TextStyle(fontSize: 24))),
      const Center(
          child: Text('Notifications Page', style: TextStyle(fontSize: 24))),
      const Center(child: Text('Profile Page', style: TextStyle(fontSize: 24))),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.blueAccent.withOpacity(0.7),
                width: 5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 0,
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: FloatingActionButton(
              child: const Icon(
                Icons.payment,
                color: Colors.white,
                size: 30,
              ),
              backgroundColor: Colors.blue,
              onPressed: () {},
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 15, top: 10),
            child: Text(
              'Send Money',
              style: TextStyle(fontSize: 12),
            ),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: _pages[_currentIndex],
      bottomNavigationBar: SizedBox(
        height: 70,
        width: MediaQuery.of(context).size.width,
        child: Card(
          elevation: 1,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildBottomNavItem(Icons.home, 'Home', 0),
              _buildBottomNavItem(Icons.person, 'Reception', 1),
              const SizedBox(width: 100),
              _buildBottomNavItem(Icons.history, 'History', 2),
              _buildBottomNavItem(Icons.settings, 'Settings', 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(IconData icon, String label, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index; // Update current index
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(icon,
                color: _currentIndex == index ? Colors.blue : Colors.grey),
            Text(
              label,
              style: TextStyle(
                  fontSize: 12,
                  color: _currentIndex == index ? Colors.blue : Colors.grey),
            )
          ],
        ),
      ),
    );
  }
}

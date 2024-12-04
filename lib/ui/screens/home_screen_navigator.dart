import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreenNavigator extends StatefulWidget {
  final Widget child;
  const HomeScreenNavigator({super.key, required this.child});

  @override
  _HomeScreenNavigatorState createState() => _HomeScreenNavigatorState();
}

class _HomeScreenNavigatorState extends State<HomeScreenNavigator> {
  int _selectedIndex = 0;

  final List<String> _routes = [
    '/home',
    '/packages',
    '/transactions',
    '/profile',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    context.go(_routes[index]); // Navigasi ke tab yang dipilih
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: widget.child), // Menampilkan halaman yang sesuai dengan tab
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: Colors.blue,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          elevation: 8, // Menambahkan bayangan di bawah BottomNavigationBar
          selectedIconTheme:
              const IconThemeData(size: 30), // Ukuran ikon saat dipilih
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.archive),
              label: 'Packages',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt),
              label: 'Transactions',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ));
  }
}

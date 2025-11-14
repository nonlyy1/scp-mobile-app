import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/profile_screen.dart';
import 'widgets/bottom_nav_bar.dart';
import 'providers/providers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
      ],
      child: MaterialApp(
        title: 'CaterChain SCP',
        theme: ThemeData(
          primaryColor: const Color(0xFF6B8E23),
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF6B8E23),
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Colors.white,
            selectedItemColor: Color(0xFF6B8E23),
            unselectedItemColor: Colors.grey,
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const MainApp(),
      ),
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);
    
    final List<Widget> _screens = [
      const HomeScreen(),
      const ChatScreen(),
      const CartScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: _screens[navigationProvider.currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: navigationProvider.currentIndex,
        onTabTapped: (index) {
          navigationProvider.navigateTo(index);
        },
      ),
    );
  }
}
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'widgets/bottom_nav_bar.dart';
import 'providers/providers.dart';
import 'providers/order_provider.dart';

void main() {
  // Run inside a guarded zone. Important: initialize bindings inside the
  // same zone as runApp to avoid "Zone mismatch" errors when running on web.
  runZonedGuarded(() {
    WidgetsFlutterBinding.ensureInitialized();

    // Print Flutter framework errors to console so they can be copied from
    // the terminal when reproducing the white/blank screen.
    FlutterError.onError = (FlutterErrorDetails details) {
      // Preserve the default behaviour (prints to console in debug).
      FlutterError.presentError(details);
      // Also print stack/exception explicitly so flutter run shows it.
      try {
        // ignore: avoid_print
        print('FlutterError caught by FlutterError.onError: ${details.exceptionAsString()}');
        // ignore: avoid_print
        print(details.stack);
      } catch (_) {}
    };

    // Replace the red/blank error widget with a friendly error page to avoid
    // a white screen and make reproduction easier for users.
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('Ошибка приложения')),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Произошла ошибка во время выполнения. Проверьте консоль/терминал для стека вызовов.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      // Simple reload: restart the app by rebuilding root.
                      // This is a best-effort; users can also hot-restart or reload the page.
                      runApp(const MyApp());
                    },
                    child: const Text('Перезапустить приложение'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    };

    runApp(const MyApp());
  }, (error, stack) {
    // Log uncaught zone errors to the terminal to make them easy to copy.
    // ignore: avoid_print
    print('Uncaught zone error: $error');
    // ignore: avoid_print
    print(stack);
  });
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
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => SupplierLinkProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => ComplaintProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
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
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/home': (context) => const MainApp(),
        },
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    // Пытаемся загрузить сохраненного пользователя
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).loadSavedUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        if (userProvider.isLoggedIn) {
          return const MainApp();
        } else {
          return const LoginScreen();
        }
      },
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
  void initState() {
    super.initState();
    // Загружаем данные при входе
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).loadMockProducts();
    });
  }

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
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/session_provider.dart';
import 'screens/dashboard_page.dart';
import 'screens/login_page.dart';
import 'utils/api_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiConfig.initialize(); // Initialize API config from saved settings
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SessionProvider(),
      child: MaterialApp(
        title: 'Mobile Banking',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'DMSans',
          primaryColor: const Color(0xFF1E1E2C),
          scaffoldBackgroundColor: const Color(0xFF1E1E2C),
        ),
        home: Consumer<SessionProvider>(
          builder: (context, session, _) {
            return session.isLoggedIn 
                ? const DashboardPage() 
                : const LoginPage();
          },
        ),
      ),
    );
  }
}

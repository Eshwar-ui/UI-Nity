import 'package:design_editor_app/screens/spalshscreen.dart';
import 'package:design_editor_app/services/auth_service.dart';
import 'package:design_editor_app/services/component_library_provider.dart';
import 'package:design_editor_app/services/component_service.dart';
import 'package:design_editor_app/services/ai_prompt_service.dart';
import 'package:design_editor_app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'theme/theme_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'utils/app_logger.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    appLogger.i('Initializing Flutter bindings');

    // // Load environment variables
    // await dotenv.load(fileName: ".env");
    // appLogger.i('Loaded .env file');

    const supabaseUrl = 'https://kppuowhptpzxnklxyfga.supabase.co';
    const supabaseAnonKey =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtwcHVvd2hwdHB6eG5rbHh5ZmdhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTA0OTU3MjIsImV4cCI6MjA2NjA3MTcyMn0.ke-hzRrAkLv89DfKcUyyMIWEomoeI5ny_7WQwrTpAaQ';

    if (supabaseUrl == null || supabaseAnonKey == null) {
      appLogger.e('Missing Supabase configuration in .env file');
      throw Exception('Missing Supabase configuration in .env file');
    }

    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
    appLogger.i('Supabase initialized');
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthService>(create: (_) => AuthService()),
          ChangeNotifierProvider<ComponentService>(
            create: (_) => ComponentService(),
          ),
          ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => ComponentLibraryProvider()),
          ChangeNotifierProvider<AIPromptService>(
            create: (_) => AIPromptService(),
          ),
        ],
        child: const MyApp(),
      ),
    );
  } catch (e, stackTrace) {
    appLogger.e(
      'Error during app initialization',
      error: e,
      stackTrace: stackTrace,
    );
    runApp(InitializationErrorApp(error: e));
  }
}

class ConnectivityOverlay extends StatefulWidget {
  final Widget child;
  const ConnectivityOverlay({super.key, required this.child});

  @override
  State<ConnectivityOverlay> createState() => _ConnectivityOverlayState();
}

class _ConnectivityOverlayState extends State<ConnectivityOverlay> {
  final Connectivity _connectivity = Connectivity();
  late final Stream<ConnectivityResult> _connectivityStream;
  PersistentBottomSheetController? _bottomSheetController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _connectivityStream = _connectivity.onConnectivityChanged;
    _connectivityStream.listen(_handleConnectivityChange);
    _checkInitialConnection();
  }

  Future<void> _checkInitialConnection() async {
    final result = await _connectivity.checkConnectivity();
    _handleConnectivityChange(result);
  }

  void _handleConnectivityChange(ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      if (_bottomSheetController == null && _scaffoldKey.currentState != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _bottomSheetController = _scaffoldKey.currentState!.showBottomSheet(
            (context) => Container(
              color: Colors.red[50],
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
              child: const Row(
                children: [
                  Icon(Icons.wifi_off, color: Colors.red, size: 32),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'No Internet Connection.\nPlease turn on your internet to use the app.',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            elevation: 10,
            backgroundColor: Colors.red[50],
          );
        });
      }
    } else {
      _bottomSheetController?.close();
      _bottomSheetController = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(key: _scaffoldKey, body: widget.child);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          title: 'UI-Nity',
          home: const ConnectivityOverlay(child: SplashScreen()),
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.isDarkMode
              ? ThemeMode.dark
              : ThemeMode.light,
        );
      },
    );
  }
}

/// A widget to display when a critical initialization error occurs before the
/// main app can run.
class InitializationErrorApp extends StatelessWidget {
  final Object error;

  const InitializationErrorApp({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Failed to initialize the application. Please try again later.\n\nDetails: $error',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'services/app_api.dart';
import 'services/api_service.dart';
import 'pages/main_navigation.dart';
import 'pages/login_page.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(CvFlutterApp());
}

class CvFlutterApp extends StatefulWidget {
  CvFlutterApp({super.key, AppApi? api}) : api = api ?? ApiService();

  final AppApi api;

  @override
  State<CvFlutterApp> createState() => _CvFlutterAppState();
}

class _CvFlutterAppState extends State<CvFlutterApp> {
  bool _isAuthenticated = false;
  bool _isRestoringSession = true;
  String? _restoreError;

  @override
  void initState() {
    super.initState();
    widget.api.onUnauthorized = _handleUnauthorized;
    _restoreSession();
  }

  void _restoreSession() {
    widget.api.getToken().then(
      (token) {
        if (!mounted) return;
        setState(() {
          _isAuthenticated = token != null;
          _isRestoringSession = false;
          _restoreError = null;
        });
      },
      onError: (Object error) {
        if (!mounted) return;
        setState(() {
          _isRestoringSession = false;
          _restoreError = error.toString();
        });
      },
    );
  }

  @override
  void didUpdateWidget(covariant CvFlutterApp oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.api != widget.api) {
      oldWidget.api.onUnauthorized = null;
      widget.api.onUnauthorized = _handleUnauthorized;
      _isRestoringSession = true;
      _restoreSession();
    }
  }

  void _handleUnauthorized() {
    if (!mounted || !_isAuthenticated) return;
    setState(() => _isAuthenticated = false);
  }

  void _logout() {
    widget.api.logout();
    setState(() => _isAuthenticated = false);
  }

  @override
  void dispose() {
    widget.api.onUnauthorized = null;
    widget.api.logout();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'cv_flutter_levis',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: _isRestoringSession
          ? const Scaffold(body: Center(child: CircularProgressIndicator()))
          : _restoreError != null
              ? Scaffold(
                  body: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Impossible de restaurer la session : '
                            '$_restoreError',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          FilledButton(
                            onPressed: () {
                              setState(() {
                                _isRestoringSession = true;
                                _restoreError = null;
                              });
                              _restoreSession();
                            },
                            child: const Text('Réessayer'),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : _isAuthenticated
                  ? MainNavigation(api: widget.api, onLogout: _logout)
                  : LoginPage(
                      api: widget.api,
                      onLoginSuccess: () =>
                          setState(() => _isAuthenticated = true),
                    ),
    );
  }
}

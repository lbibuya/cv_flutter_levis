import 'package:flutter/material.dart';

import '../screens/home_page.dart';
import '../services/app_api.dart';

class MainNavigation extends StatelessWidget {
  const MainNavigation({
    required this.api,
    required this.onLogout,
    super.key,
  });

  final AppApi api;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) => HomePage(api: api, onLogout: onLogout);
}

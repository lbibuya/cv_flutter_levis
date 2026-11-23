import 'package:flutter/material.dart';

import '../services/app_api.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_card.dart';
import '../widgets/navigation_bar.dart';
import 'contact_page.dart';
import 'cv_page.dart';
import 'family_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    required this.api,
    required this.onLogout,
    super.key,
  });

  final AppApi api;
  final VoidCallback onLogout;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const _titles = ['Accueil', 'Mon CV', 'Ma famille', 'Me contacter'];

  @override
  Widget build(BuildContext context) {
    final pages = [
      _WelcomeTab(
        onNavigate: (index) => setState(() => _selectedIndex = index),
      ),
      const CvPage(),
      FamilyPage(api: widget.api),
      const ContactPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        actions: [
          IconButton(
            tooltip: 'Se déconnecter',
            onPressed: widget.onLogout,
            icon: const Icon(Icons.logout_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: IndexedStack(index: _selectedIndex, children: pages),
      ),
      bottomNavigationBar: AppNavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
      ),
    );
  }
}

class _WelcomeTab extends StatelessWidget {
  const _WelcomeTab({required this.onNavigate});

  final ValueChanged<int> onNavigate;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      children: [
        Container(
          padding: const EdgeInsets.all(26),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF244C7B), Color(0xFF112743)],
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x24142B4A),
                blurRadius: 24,
                offset: Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const ProfileAvatar(
                    imagePath: 'assets/images/levis.jpg',
                    fallback: 'L',
                    radius: 34,
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PORTFOLIO PERSONNEL',
                          style: TextStyle(
                            color: Color(0xFFB8D5FF),
                            fontSize: 11,
                            letterSpacing: 1.6,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Goma, RDC',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_outward_rounded,
                      color: Color(0xFFB8D5FF)),
                ],
              ),
              const SizedBox(height: 28),
              Text(
                'Bonjour, je suis',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: const Color(0xFFD8E4F2),
                    ),
              ),
              const SizedBox(height: 5),
              Text(
                'Levis BIBUYA\nTSIBIRA',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      height: 1.08,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 13),
              Text(
                'Étudiant en LIC4 LSI · ISIG Goma',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: const Color(0xFFB8D5FF),
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 20),
              const Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.location_on_outlined,
                          size: 18, color: Color(0xFFB8D5FF)),
                      SizedBox(width: 6),
                      Text(
                        'Adresse : Goma / RDC',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.male_rounded,
                          size: 18, color: Color(0xFFB8D5FF)),
                      SizedBox(width: 4),
                      Text(
                        'Masculin',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        const SectionHeading(
          title: 'Explorez mon univers',
          subtitle: 'Mon parcours, mes proches et mes coordonnées.',
        ),
        const SizedBox(height: 4),
        _FeatureTile(
          icon: Icons.badge_outlined,
          title: 'Mon CV',
          description: 'Formation, compétences et centres d’intérêt.',
          onTap: () => onNavigate(1),
        ),
        const SizedBox(height: 12),
        _FeatureTile(
          icon: Icons.family_restroom_rounded,
          title: 'Ma famille',
          description: 'Les personnes qui comptent le plus pour moi.',
          onTap: () => onNavigate(2),
        ),
        const SizedBox(height: 12),
        _FeatureTile(
          icon: Icons.mail_outline_rounded,
          title: 'Me contacter',
          description: 'Restons en contact pour échanger.',
          onTap: () => onNavigate(3),
        ),
        const SizedBox(height: 18),
      ],
    );
  }
}

class _FeatureTile extends StatelessWidget {
  const _FeatureTile({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppTheme.paleBlue,
                foregroundColor: AppTheme.navy,
                child: Icon(icon),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 3),
                    Text(description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.blueGrey,
                            )),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, size: 15),
            ],
          ),
        ),
      ),
    );
  }
}

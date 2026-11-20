import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/app_theme.dart';
import '../widgets/custom_card.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  static final _contacts = [
    _ContactItem(
      icon: Icons.phone_outlined,
      label: 'Téléphone',
      value: '+243 974 625 539',
      uri: Uri(scheme: 'tel', path: '+243974625539'),
    ),
    _ContactItem(
      icon: Icons.email_outlined,
      label: 'E-mail',
      value: 'lbibuya@gmail.com',
      uri: Uri(scheme: 'mailto', path: 'lbibuya@gmail.com'),
    ),
    const _ContactItem(
      icon: Icons.location_on_outlined,
      label: 'Adresse',
      value: 'Ville de Goma / RDC',
    ),
  ];

  Future<void> _openContact(BuildContext context, _ContactItem item) async {
    final destination = item.uri!;
    try {
      final launched = await launchUrl(
        destination,
        mode: LaunchMode.platformDefault,
      );
      if (!launched && context.mounted) {
        _showError(context, 'Impossible d’ouvrir ${item.label.toLowerCase()}.');
      }
    } on Exception {
      if (context.mounted) {
        _showError(context, 'Impossible d’ouvrir ${item.label.toLowerCase()}.');
      }
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      children: [
        CustomCard(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 28,
                backgroundColor: AppTheme.paleBlue,
                child: Icon(Icons.connect_without_contact_rounded,
                    color: AppTheme.navy, size: 28),
              ),
              const SizedBox(height: 16),
              Text(
                'Faisons connaissance',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 7),
              Text(
                'N’hésitez pas à me contacter pour échanger sur une '
                'formation, un projet ou une collaboration.',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(height: 1.45, color: Colors.blueGrey),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        for (final item in _contacts) ...[
          _ContactCard(
            item: item,
            onTap: item.uri != null ? () => _openContact(context, item) : null,
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _ContactItem {
  const _ContactItem({
    required this.icon,
    required this.label,
    required this.value,
    this.uri,
  });

  final IconData icon;
  final String label;
  final String value;
  final Uri? uri;
}

class _ContactCard extends StatelessWidget {
  const _ContactCard({required this.item, this.onTap});

  final _ContactItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: EdgeInsets.zero,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: AppTheme.paleBlue,
          foregroundColor: AppTheme.navy,
          child: Icon(item.icon),
        ),
        title: Text(item.label,
            style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(item.value),
        trailing: onTap == null
            ? null
            : const Icon(Icons.open_in_new_rounded, size: 19),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/custom_card.dart';

class CvPage extends StatelessWidget {
  const CvPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF244C7B), Color(0xFF112743)],
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1F142B4A),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFB8D5FF),
                        width: 2,
                      ),
                    ),
                    child: const ProfileAvatar(
                      imagePath: 'assets/images/levis.jpg',
                      fallback: 'L',
                      radius: 36,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'BIBUYA TSIBIRA Levis',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'LIC4 LSI · ISIG Goma',
                          style: TextStyle(
                            color: Color(0xFFB8D5FF),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const Text(
                'Étudiant en LIC4 LSI à l’ISIG Goma, je m’intéresse aux '
                'systèmes informatiques, aux réseaux et aux '
                'télécommunications.',
                style: TextStyle(height: 1.55, color: Color(0xFFE0E9F4)),
              ),
              const SizedBox(height: 16),
              const Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _ProfileBadge(
                    icon: Icons.location_on_outlined,
                    label: 'Goma, RDC',
                  ),
                  _ProfileBadge(
                    icon: Icons.school_outlined,
                    label: 'ISIG Goma',
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 26),
        const SectionHeading(title: 'Formation'),
        const _TimelineCard(
          icon: Icons.school_rounded,
          title: 'ISIG Goma',
          subtitle: 'Systèmes informatiques · 2024 à nos jours',
          description: 'Étudiant en LIC4 LSI à l’ISIG Goma.',
        ),
        const SizedBox(height: 12),
        const _TimelineCard(
          icon: Icons.workspace_premium_outlined,
          title: 'Lycée Anuarite',
          subtitle: 'Diplôme en électronique générale · 2017–2023',
          description: 'Lycée Anuarite.',
        ),
        const SizedBox(height: 26),
        const _TimelineCard(
          icon: Icons.school_rounded,
          title: 'EP Sabinyinyo',
          subtitle: 'Certificat de fin d’études primaires · 2010–2016',
          description: 'Études primaires achevées à l’EP Sabinyinyo.',
        ),
        const SizedBox(height: 26),
        const SectionHeading(title: 'Formations complémentaires'),
        const _TimelineCard(
          icon: Icons.web_rounded,
          title: 'Programmation web',
          subtitle: 'Formation · 2024',
          description: 'HTML, CSS et JavaScript.',
        ),
        const SizedBox(height: 12),
        const _TimelineCard(
          icon: Icons.router_rounded,
          title: 'Configuration et administration réseau',
          subtitle: 'Formation · 2024',
          description: 'Configuration et administration des réseaux.',
        ),
        const SizedBox(height: 26),
        const SectionHeading(title: 'Compétences techniques'),
        const CustomCard(
          child: Column(
            children: [
              _SkillBar(label: 'HTML', value: 0.60),
              SizedBox(height: 18),
              _SkillBar(label: 'CSS', value: 0.55),
              SizedBox(height: 18),
              _SkillBar(label: 'JavaScript', value: 0.50),
              SizedBox(height: 18),
              _SkillBar(label: 'Cisco', value: 0.90),
              SizedBox(height: 18),
              _SkillBar(label: 'Télécommunications', value: 0.95),
            ],
          ),
        ),
        const SizedBox(height: 26),
        const SectionHeading(title: 'Langues'),
        const CustomCard(
          child: Wrap(
            spacing: 10,
            runSpacing: 8,
            children: [
              _LevelChip(label: 'Français · courant'),
              _LevelChip(label: 'Swahili · courant'),
              _LevelChip(label: 'Lingala · courant'),
              _LevelChip(label: 'Anglais · intermédiaire'),
            ],
          ),
        ),
        const SizedBox(height: 26),
        const SectionHeading(title: 'Centres d’intérêt'),
        const CustomCard(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _InterestChip(
                  icon: Icons.memory_rounded, label: 'Nouvelles technologies'),
              _InterestChip(
                  icon: Icons.web_rounded, label: 'Développement web'),
              _InterestChip(icon: Icons.menu_book_rounded, label: 'Lecture'),
              _InterestChip(icon: Icons.sports_soccer_rounded, label: 'Sport'),
              _InterestChip(
                  icon: Icons.lightbulb_outline_rounded, label: 'Innovation'),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProfileBadge extends StatelessWidget {
  const _ProfileBadge({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0x1FFFFFFF),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0x40FFFFFF)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: const Color(0xFFB8D5FF)),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineCard extends StatelessWidget {
  const _TimelineCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String description;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: const EdgeInsets.all(18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                const SizedBox(height: 5),
                Text(subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.blue,
                          fontWeight: FontWeight.w600,
                        )),
                const SizedBox(height: 10),
                Text(description,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SkillBar extends StatelessWidget {
  const _SkillBar({required this.label, required this.value});

  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            Text('${(value * 100).round()} %',
                style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: value,
          minHeight: 8,
          borderRadius: BorderRadius.circular(8),
          backgroundColor: AppTheme.paleBlue,
        ),
      ],
    );
  }
}

class _LevelChip extends StatelessWidget {
  const _LevelChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => Chip(
        avatar: const Icon(Icons.language_rounded, size: 18),
        label: Text(label),
        backgroundColor: AppTheme.paleBlue,
        side: BorderSide.none,
      );
}

class _InterestChip extends StatelessWidget {
  const _InterestChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Chip(
        avatar: Icon(icon, size: 18),
        label: Text(label),
        backgroundColor: AppTheme.paleBlue,
        side: BorderSide.none,
      );
}

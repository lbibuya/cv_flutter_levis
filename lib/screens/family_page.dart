import 'package:flutter/material.dart';

import '../models/family_member.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_card.dart';

class FamilyPage extends StatelessWidget {
  const FamilyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 700 ? 2 : 1;
        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          itemCount: FamilyMember.examples.length + 1,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            mainAxisExtent: 174,
          ),
          itemBuilder: (context, index) {
            if (index == 0) {
              return const _FamilyIntro();
            }
            return _FamilyMemberCard(member: FamilyMember.examples[index - 1]);
          },
        );
      },
    );
  }
}

class _FamilyIntro extends StatelessWidget {
  const _FamilyIntro();

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundColor: AppTheme.paleBlue,
            child: Icon(Icons.favorite_rounded, color: AppTheme.navy),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Mes proches',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        )),
                const SizedBox(height: 5),
                Text(
                  'Nous sommes 9 enfants : 5 garçons et 4 filles.',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.blueGrey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FamilyMemberCard extends StatelessWidget {
  const _FamilyMemberCard({required this.member});

  final FamilyMember member;

  @override
  Widget build(BuildContext context) {
    final initial = member.relationship.characters.first.toUpperCase();
    return CustomCard(
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          ProfileAvatar(
            imagePath: member.imagePath,
            fallback: initial,
            radius: 34,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(member.relationship,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppTheme.blue,
                          fontWeight: FontWeight.w700,
                        )),
                const SizedBox(height: 3),
                Text(member.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        )),
                if (member.profession != null) ...[
                  const SizedBox(height: 3),
                  Text(member.profession!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall),
                ],
                const SizedBox(height: 7),
                Text(
                  member.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.blueGrey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

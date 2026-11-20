class FamilyMember {
  const FamilyMember({
    required this.name,
    required this.relationship,
    required this.imagePath,
    required this.description,
    this.profession,
  });

  final String name;
  final String relationship;
  final String imagePath;
  final String description;
  final String? profession;

  static const examples = [
    FamilyMember(
      name: 'TSIBIRA BIBAPFUA',
      relationship: 'Père',
      imagePath: 'assets/images/papa.jpg',
      description: 'Mon père.',
    ),
    FamilyMember(
      name: 'RIZIKI BATENDE ELIZA',
      relationship: 'Mère',
      imagePath: 'assets/images/mere.jpg',
      description: 'Ma mère.',
    ),
    FamilyMember(
      name: 'Jamel',
      relationship: 'Frère',
      imagePath: 'assets/images/jamel.jpg',
      description: 'Mon frère.',
    ),
    FamilyMember(
      name: 'Jovite',
      relationship: 'Frère',
      imagePath: 'assets/images/jovite.jpg',
      description: 'Mon frère.',
    ),
    FamilyMember(
      name: 'Albert',
      relationship: 'Frère',
      imagePath: 'assets/images/albert.jpg',
      description: 'Mon frère.',
    ),
    FamilyMember(
      name: 'Innocent',
      relationship: 'Frère',
      imagePath: 'assets/images/innocent.jpg',
      description: 'Mon frère.',
    ),
    FamilyMember(
      name: 'Levis',
      relationship: 'Moi',
      imagePath: 'assets/images/levis.jpg',
      description: 'Moi.',
    ),
    FamilyMember(
      name: 'Solange',
      relationship: 'Sœur',
      imagePath: 'assets/images/solange.jpg',
      description: 'Ma sœur.',
    ),
    FamilyMember(
      name: 'Alliance',
      relationship: 'Sœur',
      imagePath: 'assets/images/alliance.jpg',
      description: 'Ma sœur.',
    ),
    FamilyMember(
      name: 'Desâges',
      relationship: 'Sœur',
      imagePath: 'assets/images/desages.jpg',
      description: 'Ma sœur.',
    ),
    FamilyMember(
      name: 'Mariannah',
      relationship: 'Sœur',
      imagePath: 'assets/images/marrianah.jpg',
      description: 'Ma sœur.',
    ),
  ];
}

class FamilyMember {
  const FamilyMember({
    required this.id,
    required this.name,
    required this.relationship,
    required this.description,
    this.profession,
    this.imageUrl,
  });

  final int? id;
  final String name;
  final String relationship;
  final String description;
  final String? profession;
  final String? imageUrl;

  factory FamilyMember.fromJson(Map<String, dynamic> json) => FamilyMember(
        id: json['id'] as int,
        name: (json['nom'] ?? json['name']) as String,
        relationship: (json['lien'] ?? json['relationship']) as String,
        description: json['description'] as String? ?? '',
        profession: json['profession'] as String?,
        imageUrl: (json['photo_url'] ?? json['image_url']) as String?,
      );

  Map<String, Object?> toJson() => {
        'nom': name,
        'lien': relationship,
        'description': description,
        'profession': profession,
        'photo_url': imageUrl,
      };
}

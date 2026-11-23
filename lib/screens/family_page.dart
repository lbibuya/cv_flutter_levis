import 'dart:async';

import 'package:flutter/material.dart';

import '../models/family_member.dart';
import '../services/app_api.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_card.dart';

class FamilyPage extends StatefulWidget {
  const FamilyPage({required this.api, super.key});

  final AppApi api;

  @override
  State<FamilyPage> createState() => _FamilyPageState();
}

class _FamilyPageState extends State<FamilyPage> {
  List<FamilyMember> _members = [];
  bool _isLoading = true;
  bool _isSaving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    unawaited(_loadMembers());
  }

  Future<void> _loadMembers() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final members = await widget.api.listFamily();
      if (mounted) setState(() => _members = members);
    } on AppApiException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _addMember() async {
    final values = await _showMemberForm();
    if (values == null) return;
    try {
      setState(() => _isSaving = true);
      final member = await widget.api.createFamilyMember(values.toMember());
      if (mounted) setState(() => _members = [..._members, member]);
      if (mounted) _showMessage('Membre ajouté.');
    } on AppApiException catch (error) {
      if (mounted) _showMessage(error.message);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _editMember(FamilyMember member) async {
    final values = await _showMemberForm(member: member);
    if (values == null) return;
    try {
      setState(() => _isSaving = true);
      final updated =
          await widget.api.updateFamilyMember(values.toMember(id: member.id));
      if (mounted) {
        setState(() {
          _members = [
            for (final item in _members)
              if (item.id == updated.id) updated else item,
          ];
        });
      }
      if (mounted) _showMessage('Membre modifié.');
    } on AppApiException catch (error) {
      if (mounted) _showMessage(error.message);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _deleteMember(FamilyMember member) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer ce membre ?'),
        content: Text('Cette action supprimera ${member.name} de la famille.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      setState(() => _isSaving = true);
      await widget.api.deleteFamilyMember(member.id!);
      if (mounted) {
        setState(() {
          _members = _members.where((item) => item.id != member.id).toList();
        });
      }
      if (mounted) _showMessage('Membre supprimé.');
    } on AppApiException catch (error) {
      if (mounted) _showMessage(error.message);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<_FamilyMemberFormData?> _showMemberForm({
    FamilyMember? member,
  }) =>
      showDialog<_FamilyMemberFormData>(
        context: context,
        builder: (_) => _FamilyMemberDialog(member: member),
      );

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _members.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null && _members.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off_outlined, size: 40),
              const SizedBox(height: 12),
              Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: _loadMembers,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      );
    }

    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 96),
          children: [
            const _FamilyIntro(),
            const SizedBox(height: 14),
            if (_members.isEmpty)
              const _EmptyFamilyCard()
            else
              for (final member in _members) ...[
                _FamilyMemberCard(
                  member: member,
                  onEdit: () => _editMember(member),
                  onDelete: () => _deleteMember(member),
                ),
                const SizedBox(height: 12),
              ],
          ],
        ),
        if (_isSaving || _isLoading)
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: LinearProgressIndicator(),
          ),
        Positioned(
          right: 20,
          bottom: 20,
          child: FloatingActionButton.extended(
            onPressed: _isSaving ? null : _addMember,
            icon: const Icon(Icons.person_add_alt_1_rounded),
            label: const Text('Ajouter'),
          ),
        ),
      ],
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
                Text(
                  'Mes proches',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 5),
                Text(
                  'Gérez les membres de ma famille depuis le serveur.',
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

class _EmptyFamilyCard extends StatelessWidget {
  const _EmptyFamilyCard();

  @override
  Widget build(BuildContext context) {
    return const CustomCard(
      child: Center(
        child: Text(
          'Aucun membre pour le moment.\nAjoutez votre premier proche.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _FamilyMemberCard extends StatelessWidget {
  const _FamilyMemberCard({
    required this.member,
    required this.onEdit,
    required this.onDelete,
  });

  final FamilyMember member;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final initial = member.relationship.characters.first.toUpperCase();
    final imageUrl = member.imageUrl;
    final ImageProvider<Object>? imageProvider =
        imageUrl == null || imageUrl.isEmpty
            ? null
            : imageUrl.startsWith('assets/')
                ? AssetImage(imageUrl)
                : NetworkImage(imageUrl);
    return CustomCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            foregroundImage: imageProvider,
            backgroundColor: AppTheme.paleBlue,
            child: Text(
              initial,
              style: const TextStyle(
                color: AppTheme.navy,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.relationship,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppTheme.blue,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 3),
                Text(
                  member.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                if (member.profession != null &&
                    member.profession!.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    member.profession!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
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
          PopupMenuButton<String>(
            tooltip: 'Actions sur ${member.name}',
            onSelected: (action) {
              if (action == 'edit') onEdit();
              if (action == 'delete') onDelete();
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'edit',
                child: ListTile(
                  leading: Icon(Icons.edit_outlined),
                  title: Text('Modifier'),
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: ListTile(
                  leading: Icon(Icons.delete_outline_rounded),
                  title: Text('Supprimer'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FamilyMemberDialog extends StatefulWidget {
  const _FamilyMemberDialog({this.member});

  final FamilyMember? member;

  @override
  State<_FamilyMemberDialog> createState() => _FamilyMemberDialogState();
}

class _FamilyMemberDialogState extends State<_FamilyMemberDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _relationshipController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _professionController;
  late final TextEditingController _imageUrlController;

  @override
  void initState() {
    super.initState();
    final member = widget.member;
    _nameController = TextEditingController(text: member?.name ?? '');
    _relationshipController =
        TextEditingController(text: member?.relationship ?? '');
    _descriptionController =
        TextEditingController(text: member?.description ?? '');
    _professionController =
        TextEditingController(text: member?.profession ?? '');
    _imageUrlController = TextEditingController(text: member?.imageUrl ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _relationshipController.dispose();
    _descriptionController.dispose();
    _professionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(
      context,
      _FamilyMemberFormData(
        name: _nameController.text.trim(),
        relationship: _relationshipController.text.trim(),
        description: _descriptionController.text.trim(),
        profession: _nullableText(_professionController.text),
        imageUrl: _nullableText(_imageUrlController.text),
      ),
    );
  }

  String? _nullableText(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.member == null ? 'Ajouter un proche' : 'Modifier'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                autofocus: true,
                decoration: const InputDecoration(labelText: 'Nom'),
                validator: _requiredValidator,
              ),
              TextFormField(
                controller: _relationshipController,
                decoration: const InputDecoration(labelText: 'Lien familial'),
                validator: _requiredValidator,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 2,
              ),
              TextFormField(
                controller: _professionController,
                decoration: const InputDecoration(labelText: 'Profession'),
              ),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                  labelText: 'URL de la photo (facultatif)',
                ),
                keyboardType: TextInputType.url,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        FilledButton(
          onPressed: _submit,
          child: const Text('Enregistrer'),
        ),
      ],
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ce champ est obligatoire.';
    }
    return null;
  }
}

class _FamilyMemberFormData {
  const _FamilyMemberFormData({
    required this.name,
    required this.relationship,
    required this.description,
    required this.profession,
    required this.imageUrl,
  });

  final String name;
  final String relationship;
  final String description;
  final String? profession;
  final String? imageUrl;

  FamilyMember toMember({int? id}) => FamilyMember(
        id: id,
        name: name,
        relationship: relationship,
        description: description,
        profession: profession,
        imageUrl: imageUrl,
      );
}

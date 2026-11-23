import 'package:flutter/material.dart';

import '../services/app_api.dart';
import '../theme/app_theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    required this.api,
    required this.onLoginSuccess,
    super.key,
  });

  final AppApi api;
  final VoidCallback onLoginSuccess;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isSigningIn = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSigningIn = true);
    try {
      await widget.api.login(
        _emailController.text.trim(),
        _passwordController.text,
      );
      if (mounted) widget.onLoginSuccess();
    } on AppApiException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              error.statusCode == 401
                  ? 'Identifiants incorrects - Vérifiés par le serveur'
                  : error.message,
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
    } finally {
      if (mounted) setState(() => _isSigningIn = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 820;
          return DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFF7F9FD), Color(0xFFEAF1FA)],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isWide ? 36 : 22,
                    vertical: 28,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1120),
                    child: isWide
                        ? Row(
                            children: [
                              const Expanded(flex: 6, child: _WelcomePanel()),
                              const SizedBox(width: 28),
                              Expanded(flex: 5, child: _loginCard(context)),
                            ],
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const _CompactWelcome(),
                              const SizedBox(height: 22),
                              _loginCard(context),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _loginCard(BuildContext context) {
    return Card(
      elevation: 8,
      shadowColor: const Color(0x1A142B4A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Connexion',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppTheme.navy,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 7),
              Text(
                'Accédez à mon parcours et à mon univers.',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.blueGrey.shade600),
              ),
              const SizedBox(height: 26),
              TextFormField(
                controller: _emailController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Adresse e-mail',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Veuillez saisir votre identifiant.'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                onFieldSubmitted: (_) => _signIn(),
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  suffixIcon: IconButton(
                    tooltip: _obscurePassword
                        ? 'Afficher le mot de passe'
                        : 'Masquer le mot de passe',
                    onPressed: () => setState(
                      () => _obscurePassword = !_obscurePassword,
                    ),
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Veuillez saisir votre mot de passe.'
                    : null,
              ),
              const SizedBox(height: 22),
              SizedBox(
                height: 54,
                child: FilledButton.icon(
                  onPressed: _isSigningIn ? null : _signIn,
                  icon: _isSigningIn
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.arrow_forward_rounded),
                  label: Text(
                    _isSigningIn ? 'Connexion…' : 'Découvrir mon CV',
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: AppTheme.paleBlue,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.verified_user_outlined,
                        size: 18, color: AppTheme.navy),
                    SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Vos identifiants sont vérifiés par le serveur.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppTheme.navy,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WelcomePanel extends StatelessWidget {
  const _WelcomePanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 500),
      padding: const EdgeInsets.all(42),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E416B), Color(0xFF10243F)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x24142B4A),
            blurRadius: 30,
            offset: Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const _BrandMark(size: 66),
              const SizedBox(width: 14),
              Text(
                'cv_flutter_levis',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 36),
          Text(
            'BIENVENUE DANS MON UNIVERS',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: const Color(0xFFB8D5FF),
                  letterSpacing: 2,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 18),
          Text(
            'Le talent se construit.\\nL’avenir se code.',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: Colors.white,
                  height: 1.12,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 20),
          Text(
            'Je suis Levis BIBUYA TSIBIRA, étudiant en systèmes '
            'informatiques à Goma. Découvrez mon parcours, mes compétences '
            'et les personnes qui m’inspirent.',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: const Color(0xFFD8E4F2),
                  height: 1.6,
                ),
          ),
          const SizedBox(height: 36),
          const Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _WelcomeBadge(icon: Icons.code_rounded, label: 'Informatique'),
              _WelcomeBadge(
                  icon: Icons.web_rounded, label: 'Développement web'),
              _WelcomeBadge(icon: Icons.lightbulb_outline, label: 'Innovation'),
            ],
          ),
        ],
      ),
    );
  }
}

class _CompactWelcome extends StatelessWidget {
  const _CompactWelcome();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _BrandMark(size: 62),
        const SizedBox(height: 16),
        Text(
          'Bienvenue sur mon CV',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppTheme.navy,
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 6),
        Text(
          'Levis BIBUYA TSIBIRA · Étudiant en informatique',
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Colors.blueGrey.shade700),
        ),
      ],
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFFB8D5FF),
        borderRadius: BorderRadius.circular(size * 0.32),
      ),
      alignment: Alignment.center,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size * 0.32),
        child: Image.asset(
          'assets/images/levis.jpg',
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Text(
            'L',
            style: TextStyle(
              color: AppTheme.navy,
              fontSize: size * 0.52,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

class _WelcomeBadge extends StatelessWidget {
  const _WelcomeBadge({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0x1FFFFFFF),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0x40FFFFFF)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 17, color: Colors.white),
          const SizedBox(width: 7),
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

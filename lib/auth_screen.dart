import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLogin = true;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      if (_isLogin) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
      } else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() => _error = _mensagemErro(e.code));
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  String _mensagemErro(String code) => switch (code) {
        'invalid-email' => 'E-mail inválido.',
        'user-not-found' ||
        'wrong-password' ||
        'invalid-credential' =>
          'E-mail ou senha incorretos.',
        'email-already-in-use' => 'Este e-mail já está cadastrado.',
        'weak-password' => 'Senha muito fraca. Use pelo menos 6 caracteres.',
        _ => 'Erro inesperado. Tente novamente.',
      };

  void _toggleMode() {
    setState(() {
      _isLogin = !_isLogin;
      _error = null;
    });
    _formKey.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) {
    final title = _isLogin ? 'Liga Pokémon' : 'Registro de Treinador';
    final subtitle = _isLogin
        ? 'Entre para acessar sua Pokédex.'
        : 'Crie sua conta para salvar seus Pokémon.';

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 32),
                    Center(
                      child: Container(
                        width: 96,
                        height: 96,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.catching_pokemon,
                          color: Colors.white,
                          size: 54,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'E-mail',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                      validator: (value) {
                        final email = value?.trim() ?? '';
                        if (email.isEmpty) return 'Informe seu e-mail.';
                        if (!email.contains('@')) {
                          return 'Informe um e-mail válido.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Senha',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                      ),
                      validator: (value) {
                        final password = value ?? '';
                        if (password.isEmpty) return 'Informe sua senha.';
                        if (!_isLogin && password.length < 6) {
                          return 'Use pelo menos 6 caracteres.';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) {
                        if (!_loading) _submit();
                      },
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        _error!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: _loading ? null : _submit,
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: _loading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(_isLogin ? 'Entrar' : 'Cadastrar'),
                    ),
                    TextButton(
                      onPressed: _loading ? null : _toggleMode,
                      child: Text(
                        _isLogin
                            ? 'Criar conta de treinador'
                            : 'Já tenho uma conta',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

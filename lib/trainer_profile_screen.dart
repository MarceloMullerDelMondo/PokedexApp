import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore_service.dart';

class TrainerProfileScreen extends StatefulWidget {
  const TrainerProfileScreen({super.key});

  @override
  State<TrainerProfileScreen> createState() => _TrainerProfileScreenState();
}

class _TrainerProfileScreenState extends State<TrainerProfileScreen> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int _selectedAvatar = 0;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final doc = await FirestoreService.trainerProfile.get();
    if (doc.exists) {
      final data = doc.data()!;
      setState(() {
        _nameController.text = data['name'] as String? ?? '';
        _selectedAvatar = data['avatarIndex'] as int? ?? 0;
      });
    }
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    await FirestoreService.trainerProfile.set({
      'name': _nameController.text.trim(),
      'avatarIndex': _selectedAvatar,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    setState(() => _saving = false);

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Perfil salvo!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Perfil do Treinador'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Campo nome
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nome do Treinador',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Campo obrigatório';
                      }
                      if (value.trim().length < 2) {
                        return 'Mínimo 2 caracteres';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Grade de avatares
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Escolha seu avatar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      GridView.count(
                        crossAxisCount: 3,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: List.generate(6, (i) {
                          final isSelected = _selectedAvatar == i;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedAvatar = i),
                            child: Container(
                              margin: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.red
                                      : Colors.transparent,
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                color: isSelected
                                    ? Colors.red.shade50
                                    : Colors.transparent,
                              ),
                              child: Image.asset(
                                'assets/trainers/trainer_${i + 1}.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Botão salvar
              ElevatedButton(
                onPressed: _saving ? null : _salvar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: _saving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Salvar', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

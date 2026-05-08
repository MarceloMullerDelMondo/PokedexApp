import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'pokemon_service.dart';

class NewPokemonScreen extends StatefulWidget {
  const NewPokemonScreen({super.key});

  @override
  State<NewPokemonScreen> createState() => _NewPokemonScreenState();
}

class _NewPokemonScreenState extends State<NewPokemonScreen> {
  // Fase 1: busca
  late Future<List<String>> _searchFuture;
  final _queryController = TextEditingController();

  // Fase 2: formulário
  Map<String, dynamic>? _selected;
  bool _loadingDetails = false;
  final _levelController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _searchFuture = PokemonService.fetchPokemonNames();
  }

  @override
  void dispose() {
    _queryController.dispose();
    _levelController.dispose();
    super.dispose();
  }

  // Ação 1: buscar
  void _buscar() {
    final query = _queryController.text.trim();
    setState(() {
      _searchFuture = query.isEmpty
          ? PokemonService.fetchPokemonNames()
          : PokemonService.fetchPokemonByName(query);
    });
  }

  // Ação 2: selecionar Pokémon da lista
  Future<void> _selectPokemon(String name) async {
    setState(() => _loadingDetails = true);
    final details = await PokemonService.fetchPokemonDetails(name);
    setState(() {
      _selected = details;
      _loadingDetails = false;
    });
  }

  // Ação 3: salvar no Firestore
  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    await FirebaseFirestore.instance.collection('pokemons').add({
      'name': _selected!['name'],
      'spriteUrl': _selected!['spriteUrl'],
      'types': _selected!['types'],
      'level': int.parse(_levelController.text.trim()),
      'moves': [],
    });

    if (mounted) Navigator.pop(context);
  }

  // UI fase 1: lista de busca
  Widget _buildList() {
    return Column(
      children: [
        // Campo de busca
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _queryController,
                  decoration: const InputDecoration(
                    labelText: 'Buscar Pokémon',
                    border: OutlineInputBorder(),
                    hintText: 'Ex: pikachu',
                  ),
                  onSubmitted: (_) => _buscar(),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _buscar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 18,
                  ),
                ),
                child: const Text('Buscar'),
              ),
            ],
          ),
        ),

        // Lista via FutureBuilder
        Expanded(
          child: FutureBuilder<List<String>>(
            future: _searchFuture,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    '${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                );
              }
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final names = snapshot.data!;
              return ListView.builder(
                itemCount: names.length,
                itemBuilder: (context, i) => ListTile(
                  leading: const Icon(
                    Icons.catching_pokemon,
                    color: Colors.red,
                  ),
                  title: Text(
                    names[i],
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _selectPokemon(names[i]),
                ),
              );
            },
          ),
        ),

        // Spinner de carregamento de detalhes
        if (_loadingDetails)
          const Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }

  // UI fase 2: formulário com preview
  Widget _buildForm() {
    final spriteUrl = _selected!['spriteUrl'] as String;
    final name = _selected!['name'] as String;
    final types = _selected!['types'] as List<dynamic>;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Card de preview
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Image.network(spriteUrl, height: 80, width: 80),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: types
                                .map(
                                  (t) => Chip(
                                    label: Text(t as String),
                                    visualDensity: VisualDensity.compact,
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () => setState(() => _selected = null),
                      child: const Text('Trocar'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Campo nível
            TextFormField(
              controller: _levelController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Nível inicial',
                border: OutlineInputBorder(),
                hintText: 'Entre 1 e 100',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Campo obrigatório';
                }
                final n = int.tryParse(value.trim());
                if (n == null || n < 1 || n > 100) {
                  return 'Digite um número entre 1 e 100';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Botão cadastrar
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
                  : const Text('Cadastrar', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Novo Pokémon'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: _selected == null ? _buildList() : _buildForm(),
    );
  }
}

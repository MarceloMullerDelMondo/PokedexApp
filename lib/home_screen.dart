import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firestore_service.dart';
import 'pokemon.dart';
import 'pokemon_screen.dart';
import 'new_pokemon_screen.dart';
import 'trainer_profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Recarrega o perfil ao voltar da TrainerProfileScreen.
  Future<Map<String, dynamic>?> _loadTrainerProfile() async {
    final doc = await FirestoreService.trainerProfile.get();
    if (doc.exists) return doc.data();
    return null;
  }

  String _getSpriteUrl(Map<String, dynamic> data) {
    final raw = data['spriteUrl'];
    if (raw is String && raw.isNotEmpty) return raw;
    final id = data['spriteId'];
    if (id != null) {
      return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';
    }
    return '';
  }

  List<String> _getTypes(Map<String, dynamic> data) {
    final raw = data['types'];
    if (raw == null) return [];
    return (raw as List<dynamic>).map((t) => t.toString()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Pokédex', style: TextStyle(fontSize: 18)),
            Text(
              FirebaseAuth.instance.currentUser?.email ?? '',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        actions: [
          FutureBuilder<Map<String, dynamic>?>(
            future: _loadTrainerProfile(),
            builder: (context, snapshot) {
              final avatarIndex = snapshot.data?['avatarIndex'] as int? ?? -1;

              return IconButton(
                tooltip: 'Perfil do Treinador',
                icon: avatarIndex >= 0
                    ? ClipOval(
                        child: Image.asset(
                          'assets/trainers/trainer_${avatarIndex + 1}.png',
                          width: 32,
                          height: 32,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Icon(Icons.person),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TrainerProfileScreen(),
                    ),
                  );
                  // Força rebuild para atualizar o avatar no AppBar
                  setState(() {});
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: () => FirebaseAuth.instance.signOut(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NewPokemonScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: FirestoreService.pokemons.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(
              child: Text(
                'Nenhum Pokémon cadastrado.\nToque em + para adicionar!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data();
              final docId = docs[index].id;
              final spriteUrl = _getSpriteUrl(data);
              final types = _getTypes(data);

              final pokemon = Pokemon(
                name: data['name'] ?? '',
                spriteUrl: spriteUrl,
                typeIds: const [],
                level: data['level'] ?? 1,
                moves: List<String>.from(data['moves'] ?? []),
                latitude: (data['latitude'] as num?)?.toDouble(),
                longitude: (data['longitude'] as num?)?.toDouble(),
              );

              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage:
                        spriteUrl.isNotEmpty ? NetworkImage(spriteUrl) : null,
                    child: spriteUrl.isEmpty
                        ? const Icon(Icons.catching_pokemon)
                        : null,
                  ),
                  title: Text(
                    pokemon.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('Nível ${pokemon.level}'),
                          if (pokemon.hasLocation) ...[
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.place,
                              size: 14,
                              color: Colors.deepPurple,
                            ),
                          ],
                        ],
                      ),
                      if (types.isNotEmpty)
                        Wrap(
                          spacing: 4,
                          children: types
                              .map(
                                (t) => Chip(
                                  label: Text(
                                    t,
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                  padding: EdgeInsets.zero,
                                  visualDensity: VisualDensity.compact,
                                ),
                              )
                              .toList(),
                        ),
                    ],
                  ),
                  isThreeLine: true,
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await FirestoreService.pokemons.doc(docId).delete();
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            PokemonScreen(pokemon: pokemon, docId: docId),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

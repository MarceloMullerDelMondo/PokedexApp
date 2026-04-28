import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'pokemon.dart';
import 'pokemon_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final collection = FirebaseFirestore.instance.collection('pokemons');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Pokédex'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder(
        stream: collection.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final docId = docs[index].id;

              final pokemon = Pokemon(
                name: data['name'] ?? '',
                spriteId: data['spriteId'] ?? 1,
                typeIds: List<int>.from(data['types'] ?? []),
                level: data['level'] ?? 1,
                moves: List<String>.from(data['moves'] ?? []),
              );

              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: NetworkImage(pokemon.spriteUrl),
                  ),
                  title: Text(
                    pokemon.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text('Nível ${pokemon.level}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await collection.doc(docId).delete();
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

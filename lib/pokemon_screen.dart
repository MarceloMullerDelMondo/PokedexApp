import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firestore_service.dart';
import 'pokemon.dart';
import 'battle_provider.dart';
import 'stat_bar.dart';

class PokemonScreen extends StatelessWidget {
  final Pokemon pokemon;
  final String docId;

  const PokemonScreen({super.key, required this.pokemon, required this.docId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BattleProvider(
        pokemonName: pokemon.name,
        level: pokemon.level,
      ),
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          title: Text(pokemon.name),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PokemonCard(pokemon: pokemon),
              const SizedBox(height: 16),
              LocationCard(pokemon: pokemon),
              const SizedBox(height: 16),
              BattlePanel(docId: docId),
              const SizedBox(height: 16),
              MoveList(pokemon: pokemon),
            ],
          ),
        ),
      ),
    );
  }
}

class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonCard({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    final level = context.select((BattleProvider p) => p.level);
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 36,
              backgroundColor: Colors.deepPurple.shade100,
              backgroundImage: pokemon.spriteUrl.isNotEmpty
                  ? NetworkImage(pokemon.spriteUrl)
                  : null,
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pokemon.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Nível $level',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.deepPurple.shade400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LocationCard extends StatelessWidget {
  final Pokemon pokemon;

  const LocationCard({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              pokemon.hasLocation ? Icons.place : Icons.location_off,
              color: pokemon.hasLocation ? Colors.deepPurple : Colors.grey,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Local da captura',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  pokemon.hasLocation
                      ? '${pokemon.latitude!.toStringAsFixed(4)}°, ${pokemon.longitude!.toStringAsFixed(4)}°'
                      : 'Localização não registrada',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BattlePanel extends StatelessWidget {
  final String docId;

  const BattlePanel({super.key, required this.docId});

  @override
  Widget build(BuildContext context) {
    final battle = context.watch<BattleProvider>();
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Nível ${battle.level}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            StatBar(
              label: 'HP',
              value: battle.hp,
              maxValue: 100,
              color: battle.hpColor,
            ),
            StatBar(
              label: 'XP',
              value: battle.xp,
              maxValue: 100,
              color: Colors.blue,
            ),
            if (battle.statusMessage.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                battle.statusMessage,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: battle.hp > 0
                        ? () => context.read<BattleProvider>().attack()
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Atacar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: battle.hp < 100
                        ? () => context.read<BattleProvider>().heal()
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Usar Poção'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final level = context.read<BattleProvider>().level;
                  await FirestoreService.pokemons
                      .doc(docId)
                      .update({'level': level});
                  if (context.mounted) Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Encerrar Batalha'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MoveList extends StatelessWidget {
  final Pokemon pokemon;

  const MoveList({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    if (pokemon.moves.isEmpty) return const SizedBox.shrink();
    return Card(
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text(
              'Golpes',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          ...pokemon.moves.map(
            (move) => ListTile(
              leading: const Icon(Icons.flash_on, color: Colors.deepPurple),
              title: Text(move),
            ),
          ),
        ],
      ),
    );
  }
}

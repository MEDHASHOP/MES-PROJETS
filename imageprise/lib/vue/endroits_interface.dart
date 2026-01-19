import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/endroits_provider.dart';
import '../widgets/endroits_list.dart';

class EndroitsInterface extends ConsumerWidget {
  const EndroitsInterface({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final endroits = ref.watch(endroitsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mes endroits préférés"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(context, '/ajout'),
          ),
        ],
      ),
      body: endroits.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.place, size: 80, color: Colors.grey),
                  const SizedBox(height: 12),
                  const Text("Pas d'endroits favoris pour le moment"),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pushNamed(context, '/ajout'),
                    icon: const Icon(Icons.add),
                    label: const Text("Ajouter un endroit"),
                  ),
                ],
              ),
            )
          : EndroitsList(endroits: endroits),
    );
  }
}

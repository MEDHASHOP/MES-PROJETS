import 'package:flutter/material.dart';
import '../modele/endroit.dart';
import '../vue/endroit_detail.dart';

class EndroitsList extends StatelessWidget {
  final List<Endroit> endroits;

  const EndroitsList({super.key, required this.endroits});

  @override
  Widget build(BuildContext context) {
    if (endroits.isEmpty) {
      return const Center(
        child: Text(
          "Pas d'endroits favoris pour le moment",
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      itemCount: endroits.length,
      itemBuilder: (context, index) {
        final e = endroits[index];
        return ListTile(
          leading: e.image != null
              ? CircleAvatar(backgroundImage: FileImage(e.image!))
              : const CircleAvatar(child: Icon(Icons.place)),
          title: Text(e.nom),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => EndroitDetail(endroit: e),
              ),
            );
          },
        );
      },
    );
  }
}

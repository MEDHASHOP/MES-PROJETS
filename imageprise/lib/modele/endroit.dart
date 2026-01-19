import 'dart:io';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class Endroit {
  final String id;
  final String nom;
  final File? image;

  Endroit({
    required this.nom,
    this.image,
  }) : id = _uuid.v4();

  Map<String, dynamic> toMap() => {
        'id': id,
        'nom': nom,
        'imagePath': image?.path,
      };

  factory Endroit.fromMap(Map<String, dynamic> map) => Endroit(
        nom: map['nom'] as String,
        image: map['imagePath'] != null ? File(map['imagePath'] as String) : null,
      );
}

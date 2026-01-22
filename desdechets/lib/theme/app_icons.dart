import 'dart:math';
import 'package:flutter/material.dart';

/// Icônes personnalisées pour l'application
class AppIcons {
  // Icône poubelle stylisée
  static Widget styledTrashIcon({
    double size = 48,
    Color color = const Color(0xFF2E7D32),
  }) {
    return CustomPaint(
      size: Size(size, size),
      painter: TrashIconPainter(color: color),
    );
  }

  // Icône recyclage stylisée
  static Widget styledRecycleIcon({
    double size = 48,
    Color color = const Color(0xFF2E7D32),
  }) {
    return CustomPaint(
      size: Size(size, size),
      painter: RecycleIconPainter(color: color),
    );
  }

  // Icône feuille (écologie)
  static Widget leafIcon({
    double size = 48,
    Color color = const Color(0xFF2E7D32),
  }) {
    return CustomPaint(
      size: Size(size, size),
      painter: LeafIconPainter(color: color),
    );
  }
}

/// Peintre pour l'icône poubelle stylisée
class TrashIconPainter extends CustomPainter {
  final Color color;

  TrashIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Couvercle
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.2, size.height * 0.1, size.width * 0.6, size.height * 0.15),
        const Radius.circular(2),
      ),
      fillPaint,
    );

    // Poignée
    canvas.drawLine(
      Offset(size.width * 0.35, size.height * 0.1),
      Offset(size.width * 0.35, size.height * 0.05),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.65, size.height * 0.1),
      Offset(size.width * 0.65, size.height * 0.05),
      paint,
    );
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * 0.05),
        width: size.width * 0.3,
        height: size.height * 0.1,
      ),
      0,
      3.14,
      false,
      paint,
    );

    // Corps de la poubelle
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.15,
          size.height * 0.25,
          size.width * 0.7,
          size.height * 0.65,
        ),
        const Radius.circular(4),
      ),
      paint,
    );

    // Lignes de détail
    canvas.drawLine(
      Offset(size.width * 0.3, size.height * 0.4),
      Offset(size.width * 0.7, size.height * 0.4),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.3, size.height * 0.55),
      Offset(size.width * 0.7, size.height * 0.55),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.3, size.height * 0.7),
      Offset(size.width * 0.7, size.height * 0.7),
      paint,
    );
  }

  @override
  bool shouldRepaint(TrashIconPainter oldDelegate) => oldDelegate.color != color;
}

/// Peintre pour l'icône recyclage stylisée
class RecycleIconPainter extends CustomPainter {
  final Color color;

  RecycleIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.35;

    // Trois flèches en cercle
    for (int i = 0; i < 3; i++) {
      final angle = (i * 2 * pi / 3) - pi / 2;
      final nextAngle = ((i + 1) * 2 * pi / 3) - pi / 2;

      final endX = center.dx + radius * cos(nextAngle);
      final endY = center.dy + radius * sin(nextAngle);

      // Arc
      canvas.drawArc(
        Rect.fromCenter(center: center, width: radius * 1.4, height: radius * 1.4),
        angle,
        2 * pi / 3 - 0.3,
        false,
        paint,
      );

      // Pointe de flèche
      final arrowSize = size.width * 0.08;
      final arrowAngle = nextAngle + pi;

      canvas.drawLine(
        Offset(endX, endY),
        Offset(
          endX + arrowSize * cos(arrowAngle - 0.4),
          endY + arrowSize * sin(arrowAngle - 0.4),
        ),
        paint,
      );
      canvas.drawLine(
        Offset(endX, endY),
        Offset(
          endX + arrowSize * cos(arrowAngle + 0.4),
          endY + arrowSize * sin(arrowAngle + 0.4),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(RecycleIconPainter oldDelegate) => oldDelegate.color != color;
}

/// Peintre pour l'icône feuille
class LeafIconPainter extends CustomPainter {
  final Color color;

  LeafIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Forme de feuille
    final path = Path();
    path.moveTo(size.width * 0.5, size.height * 0.1);
    path.quadraticBezierTo(
      size.width * 0.8,
      size.height * 0.3,
      size.width * 0.7,
      size.height * 0.7,
    );
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.9,
      size.width * 0.3,
      size.height * 0.7,
    );
    path.quadraticBezierTo(
      size.width * 0.2,
      size.height * 0.3,
      size.width * 0.5,
      size.height * 0.1,
    );
    path.close();

    canvas.drawPath(path, paint);

    // Nervure centrale
    canvas.drawLine(
      Offset(size.width * 0.5, size.height * 0.1),
      Offset(size.width * 0.5, size.height * 0.85),
      strokePaint,
    );

    // Nervures latérales
    for (int i = 1; i <= 3; i++) {
      final y = size.height * (0.2 + i * 0.15);
      canvas.drawLine(
        Offset(size.width * 0.5, y),
        Offset(size.width * (0.5 + 0.15 * i * 0.1), y),
        strokePaint,
      );
      canvas.drawLine(
        Offset(size.width * 0.5, y),
        Offset(size.width * (0.5 - 0.15 * i * 0.1), y),
        strokePaint,
      );
    }
  }

  @override
  bool shouldRepaint(LeafIconPainter oldDelegate) => oldDelegate.color != color;
}

import 'package:flutter/material.dart';

class MosqueSilhouette extends StatelessWidget {
  const MosqueSilhouette({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: MosquePainter(),
      child: Container(),
    );
  }
}

class MosquePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    final path = Path();
    
    // Main mosque building
    final buildingWidth = size.width * 0.6;
    final buildingHeight = size.height * 0.4;
    final buildingX = (size.width - buildingWidth) / 2;
    final buildingY = size.height - buildingHeight;
    
    // Main building rectangle
    path.addRect(Rect.fromLTWH(buildingX, buildingY, buildingWidth, buildingHeight));
    
    // Central dome
    final domeRadius = buildingWidth * 0.15;
    final domeX = buildingX + buildingWidth / 2;
    final domeY = buildingY - domeRadius * 0.5;
    
    path.addOval(Rect.fromCircle(
      center: Offset(domeX, domeY),
      radius: domeRadius,
    ));
    
    // Left minaret
    final minaretWidth = size.width * 0.08;
    final minaretHeight = size.height * 0.6;
    final leftMinaretX = buildingX - minaretWidth * 1.5;
    final leftMinaretY = size.height - minaretHeight;
    
    path.addRect(Rect.fromLTWH(leftMinaretX, leftMinaretY, minaretWidth, minaretHeight));
    
    // Left minaret dome
    final minaretDomeRadius = minaretWidth * 0.6;
    path.addOval(Rect.fromCircle(
      center: Offset(leftMinaretX + minaretWidth / 2, leftMinaretY),
      radius: minaretDomeRadius,
    ));
    
    // Right minaret
    final rightMinaretX = buildingX + buildingWidth + minaretWidth * 0.5;
    path.addRect(Rect.fromLTWH(rightMinaretX, leftMinaretY, minaretWidth, minaretHeight));
    
    // Right minaret dome
    path.addOval(Rect.fromCircle(
      center: Offset(rightMinaretX + minaretWidth / 2, leftMinaretY),
      radius: minaretDomeRadius,
    ));
    
    // Side domes
    final sideDomeRadius = domeRadius * 0.7;
    
    // Left side dome
    path.addOval(Rect.fromCircle(
      center: Offset(buildingX + buildingWidth * 0.25, domeY + domeRadius * 0.3),
      radius: sideDomeRadius,
    ));
    
    // Right side dome
    path.addOval(Rect.fromCircle(
      center: Offset(buildingX + buildingWidth * 0.75, domeY + domeRadius * 0.3),
      radius: sideDomeRadius,
    ));
    
    // Arched entrance
    final archWidth = buildingWidth * 0.2;
    final archHeight = buildingHeight * 0.4;
    final archX = buildingX + (buildingWidth - archWidth) / 2;
    final archY = size.height - archHeight;
    
    final archPath = Path();
    archPath.addRRect(RRect.fromRectAndRadius(
      Rect.fromLTWH(archX, archY, archWidth, archHeight),
      Radius.circular(archWidth / 2),
    ));
    
    // Subtract arch from main building (create entrance)
    path.addPath(archPath, Offset.zero);
    
    canvas.drawPath(path, paint);
    
    // Draw stars in the sky
    final starPaint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..style = PaintingStyle.fill;
    
    // Add some stars
    final stars = [
      Offset(size.width * 0.1, size.height * 0.2),
      Offset(size.width * 0.2, size.height * 0.15),
      Offset(size.width * 0.8, size.height * 0.25),
      Offset(size.width * 0.9, size.height * 0.1),
      Offset(size.width * 0.15, size.height * 0.35),
      Offset(size.width * 0.85, size.height * 0.4),
    ];
    
    for (final star in stars) {
      canvas.drawCircle(star, 2, starPaint);
    }
    
    // Draw crescent moon
    final moonPaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.fill;
    
    final moonCenter = Offset(size.width * 0.85, size.height * 0.15);
    final moonRadius = 12.0;
    
    // Full moon circle
    canvas.drawCircle(moonCenter, moonRadius, moonPaint);
    
    // Crescent cutout
    final cutoutPaint = Paint()
      ..color = Colors.transparent
      ..blendMode = BlendMode.clear;
    
    canvas.drawCircle(
      Offset(moonCenter.dx + moonRadius * 0.3, moonCenter.dy - moonRadius * 0.1),
      moonRadius * 0.8,
      cutoutPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

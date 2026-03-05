// Widgets/turnOnTabWidget.dart

import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final bool isSelected;

  const CategoryCard({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.description,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // the grey box (text container)
        Container(
          margin: const EdgeInsets.only(top: 50),
          padding: const EdgeInsets.only(
            top: 60,
            left: 8,
            right: 8,
            bottom: 12,
          ),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue[50] : Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
            border: isSelected
                ? Border.all(color: Colors.blue, width: 2)
                : null,
          ),
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.blue[800] : Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? Colors.blue[600] : Colors.grey[700],
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),

        // image overlaps box
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(color: Colors.transparent),
              child: Stack(
                children: [
                  Image.asset(imagePath, fit: BoxFit.contain),
                  if (isSelected)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// UPDATED
import 'package:flutter/material.dart';

import '../core/app_models.dart';

// UPDATED
class HeroAvatar extends StatelessWidget {
  const HeroAvatar({
    required this.hero,
    this.size = 52,
    super.key,
  });

  final AppHero hero;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.22),
        gradient: LinearGradient(
          colors: [hero.startColor, hero.endColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(size * 0.12),
        child: Image.asset(
          hero.assetPath,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Icon(
            Icons.image_outlined,
            size: size * 0.48,
            color: Colors.white.withOpacity(0.95),
          ),
        ),
      ),
    );
  }
}

// UPDATED
class HeroSelector extends StatelessWidget {
  const HeroSelector({
    required this.title,
    required this.options,
    required this.selectedIds,
    required this.onToggle,
    super.key,
  });

  final String title;
  final List<AppHero> options;
  final Set<String> selectedIds;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Color(0xFF1F2430),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 10,
              runSpacing: 10,
              children: options.map((hero) {
                final selected = selectedIds.contains(hero.id);
                return InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => onToggle(hero.id),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    width: 104,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected ? const Color(0xFFE9EEFF) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selected ? const Color(0xFF3454D1) : Colors.grey.shade300,
                        width: selected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        HeroAvatar(hero: hero, size: 56),
                        const SizedBox(height: 6),
                        Text(
                          hero.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF2C3140),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Icon(
                          selected ? Icons.check_circle : Icons.radio_button_unchecked,
                          color: selected ? const Color(0xFF3454D1) : Colors.grey,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

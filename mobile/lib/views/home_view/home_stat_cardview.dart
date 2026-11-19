import 'package:flutter/material.dart';

class HomeStatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String count;
  final Color countColor;
  final String title;
  final Color borderColor;
  final Color cardBgColor;

  const HomeStatCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.count,
    required this.countColor,
    required this.title,
    required this.borderColor,
    required this.cardBgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBgColor,
        border: Border.all(color: borderColor),
        borderRadius: const BorderRadius.all(Radius.circular(24)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
            decoration: const BoxDecoration(
              color: Color(0x14FFFFFF),
              borderRadius: BorderRadius.all(Radius.circular(14)),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(height: 24),
          Text(
            count,
            style: TextStyle(
              color: countColor,
              fontSize: 40,
              fontWeight: FontWeight.w900,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

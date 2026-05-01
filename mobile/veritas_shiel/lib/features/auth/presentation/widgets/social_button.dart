import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
  final String text;
  final String iconPath;
  final VoidCallback onPressed;

  const SocialButton({
    super.key,
    required this.text,
    required this.iconPath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          side: const BorderSide(color: Colors.black12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          backgroundColor: Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              iconPath,
              height: 24,
              width: 24,
            ),
            const SizedBox(width: 12),
            Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

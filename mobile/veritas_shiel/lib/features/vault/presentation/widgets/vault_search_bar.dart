import 'package:flutter/material.dart';
import 'package:veritas_shiel/core/theme/app_colors.dart';

class VaultSearchBar extends StatelessWidget {
  final VoidCallback? onFilterTap;
  final ValueChanged<String>? onSearchChanged;

  const VaultSearchBar({
    super.key,
    this.onFilterTap,
    this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: AppColors.darkBrown, width: 1.5),
              ),
              child: TextField(
                textAlign: TextAlign.center,
                onChanged: onSearchChanged,
                decoration: const InputDecoration(
                  hintText: 'Search existing contracts',
                  hintStyle: TextStyle(color: Colors.black38, fontSize: 14),
                  prefixIcon: Icon(Icons.search, color: AppColors.darkBrown),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          InkWell(
            onTap: onFilterTap,
            borderRadius: BorderRadius.circular(25),
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: AppColors.darkBrown, width: 1.5),
              ),
              child: const Row(
                children: [
                  Text(
                    'All',
                    style: TextStyle(color: Colors.black38, fontSize: 14),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.filter_alt_outlined, color: AppColors.darkBrown, size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

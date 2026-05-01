import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:veritas_shiel/core/theme/app_colors.dart';
import 'package:veritas_shiel/features/auth/presentation/cubit/auth_cubit.dart';

class DashboardHeader extends StatelessWidget {
  final String userName;
  const DashboardHeader({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              'Welcome to your safe Veritas Shield, $userName',
              // 'Welcome to your safe Veritas Shield, ${context.read<AuthCubit>().state.user.name}', // Use name from API
              // maxLines: 1,
              // overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.darkBrown,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(
                Icons.notifications_none_outlined,
                color: AppColors.darkBrown,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}

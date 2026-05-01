import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:veritas_shiel/core/theme/app_colors.dart';
import 'package:veritas_shiel/core/routes/app_router.dart';
import 'package:veritas_shiel/features/dashboard/presentation/widgets/dashboard_header.dart';
import 'package:veritas_shiel/features/dashboard/presentation/widgets/quick_action_card.dart';
import 'package:veritas_shiel/features/dashboard/presentation/widgets/status_card.dart';
import 'package:veritas_shiel/features/dashboard/presentation/widgets/warning_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:veritas_shiel/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:veritas_shiel/features/profile/presentation/cubit/profile_state.dart';
import 'package:veritas_shiel/features/vault/presentation/cubit/vault_cubit.dart';
import 'package:veritas_shiel/features/vault/presentation/cubit/vault_state.dart';

import 'package:file_picker/file_picker.dart';
import 'package:veritas_shiel/features/analysis/presentation/cubit/analysis_cubit.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
    context.read<ProfileCubit>().getProfile();
    context.read<VaultCubit>().getDocuments();
  }

  Future<void> _pickAndAnalyze() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null && result.files.single.path != null) {
      final path = result.files.single.path!;
      if (mounted) {
        // Here you would call your upload/analyze logic
        // For example: context.read<VaultCubit>().uploadDocument(path);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'File selected: ${result.files.single.name}. Starting analysis...',
            ),
          ),
        );
        // Navigate to analysis or show loading
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<ProfileCubit>().getProfile();
            context.read<VaultCubit>().getDocuments();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, state) {
                    final name = state is ProfileLoaded
                        ? state.user.name
                        : 'User';
                    return DashboardHeader(userName: name);
                  },
                ),
                const SizedBox(height: 16),
                BlocBuilder<VaultCubit, VaultState>(
                  builder: (context, state) {
                    int docCount = 0;
                    if (state is VaultLoaded) {
                      docCount = state.documents.length;
                    }
                    return StatusCard(
                      protectedDocs: docCount,
                      conflicts: 0,
                      conflictPercentage: 0,
                    );
                  },
                ),
                const SizedBox(height: 32),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkBrown,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        QuickActionCard(
                          title: 'Analyze new contract',
                          icon: Icons.note_add_outlined,
                          onTap: _pickAndAnalyze,
                        ),
                        const SizedBox(width: 16),
                        QuickActionCard(
                          title: 'View Legal Map',
                          icon: Icons.hub_outlined,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    'Warnings',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkBrown,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      WarningCard(
                        title: 'Lease Renewal',
                        expiryText: 'Expires in 30 days',
                      ),
                      const SizedBox(width: 16),
                      WarningCard(
                        title: 'Work contract',
                        expiryText: 'Expires in 20 days',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 100), // Spacing for bottom nav
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
          if (index == 1) {
            Navigator.pushNamed(context, Routes.analysis);
          } else if (index == 2) {
            Navigator.pushNamed(context, Routes.vault);
          } else if (index == 3) {
            Navigator.pushNamed(context, Routes.profile);
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.background,
        selectedItemColor: AppColors.darkBrown,
        unselectedItemColor: Colors.black38,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: Icon(_selectedIndex == 0 ? Icons.home : Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 1
                  ? Icons.document_scanner
                  : Icons.document_scanner_outlined,
            ),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 2 ? Icons.folder : Icons.folder_outlined,
            ),
            label: 'Files',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 3 ? Icons.person : Icons.person_outline,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

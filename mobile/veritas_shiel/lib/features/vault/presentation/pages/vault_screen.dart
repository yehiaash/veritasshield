import 'package:flutter/material.dart';
import 'package:veritas_shiel/core/theme/app_colors.dart';
import 'package:veritas_shiel/core/routes/app_router.dart';
import 'package:veritas_shiel/features/dashboard/presentation/widgets/dashboard_header.dart';
import 'package:veritas_shiel/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:veritas_shiel/features/profile/presentation/cubit/profile_state.dart';
import 'package:veritas_shiel/features/vault/presentation/widgets/vault_category_card.dart';
import 'package:veritas_shiel/features/vault/presentation/widgets/vault_search_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/vault_cubit.dart';
import '../cubit/vault_state.dart';

class VaultScreen extends StatefulWidget {
  const VaultScreen({super.key});

  @override
  State<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends State<VaultScreen> {
  int _selectedIndex = 2; // Default to 'Files' tab

  @override
  void initState() {
    super.initState();
    context.read<VaultCubit>().getDocuments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                final name = state is ProfileLoaded ? state.user.name : 'User';
                return DashboardHeader(userName: name);
              },
            ),
            const SizedBox(height: 8),
            VaultSearchBar(onFilterTap: () {}, onSearchChanged: (query) {}),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<VaultCubit, VaultState>(
                builder: (context, state) {
                  if (state is VaultLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is VaultError) {
                    return Center(child: Text(state.message));
                  } else if (state is VaultLoaded) {
                    if (state.documents.isEmpty) {
                      return const Center(child: Text('No documents found.'));
                    }
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: state.documents.length,
                      itemBuilder: (context, index) {
                        final doc = state.documents[index];
                        return VaultCategoryCard(
                          title: doc.title,
                          icon: Icons.description_outlined,
                          onTap: () {},
                        );
                      },
                    );
                  }
                  return const Center(
                    child: Text('Start by uploading a document!'),
                  );
                },
              ),
            ),
          ],
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
          if (index == 0) {
            Navigator.pushReplacementNamed(context, Routes.home);
          } else if (index == 1) {
            Navigator.pushNamed(context, Routes.analysis);
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
            label: 'Scan',
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

import 'package:flutter/material.dart';
import 'package:veritas_shiel/core/theme/app_colors.dart';
import 'package:veritas_shiel/features/dashboard/presentation/widgets/dashboard_header.dart';
import 'package:veritas_shiel/features/onboarding/presentation/widgets/custom_button.dart';
import 'package:veritas_shiel/core/routes/app_router.dart';
import 'package:veritas_shiel/features/profile/presentation/widgets/profile_text_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 3; // Default to 'Profile' tab

  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileError) {
              return Center(child: Text(state.message));
            } else if (state is ProfileLoaded) {
              final user = state.user;
              return Column(
                children: [
                  DashboardHeader(userName: user.name),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          const SizedBox(height: 24),
                          // Profile Image
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black38),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.person,
                                size: 80,
                                color: AppColors.darkBrown,
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          // Profile Form
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(40),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 15,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                ProfileTextField(
                                  label: 'Name',
                                  value: user.name,
                                ),
                                ProfileTextField(
                                  label: 'Email',
                                  value: user.email,
                                ),
                                const ProfileTextField(
                                  label: 'Password',
                                  value: '************',
                                  isPassword: true,
                                ),
                                const SizedBox(height: 32),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: CustomButton(
                                      text: 'Logout',
                                      onPressed: () {
                                        // TODO: Implement logout logic in AuthCubit
                                        Navigator.pushNamedAndRemoveUntil(context, Routes.login, (route) => false);
                                      },
                                      backgroundColor: AppColors.darkBrown,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: CustomButton(
                                      text: 'Delete Account',
                                      onPressed: () {},
                                      backgroundColor: const Color(0xFFB71C1C),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 100), // Spacing for bottom nav
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
            return const Center(child: Text('Please login to see your profile.'));
          },
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
            Navigator.pushReplacementNamed(context, Routes.analysis);
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, Routes.vault);
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

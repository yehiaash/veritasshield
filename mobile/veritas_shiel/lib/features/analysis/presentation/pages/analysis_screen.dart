import 'package:flutter/material.dart';
import 'package:veritas_shiel/core/theme/app_colors.dart';
import 'package:veritas_shiel/features/analysis/presentation/widgets/analysis_card.dart';
import 'package:veritas_shiel/features/dashboard/presentation/widgets/dashboard_header.dart';
import 'package:veritas_shiel/core/routes/app_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:veritas_shiel/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:veritas_shiel/features/profile/presentation/cubit/profile_state.dart';
import '../cubit/analysis_cubit.dart';
import '../cubit/analysis_state.dart';
import 'package:file_picker/file_picker.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  int _selectedIndex = 1; // Default to 'Scan' tab

  @override
  void initState() {
    super.initState();
    context.read<AnalysisCubit>().getAnalysisHistory();
  }

  Future<void> _pickAndAnalyze() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null && result.files.single.path != null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'File selected: ${result.files.single.name}. Starting analysis...',
            ),
          ),
        );
        // Trigger analysis logic here
      }
    }
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
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recents:',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkBrown,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _pickAndAnalyze,
                    icon: const Icon(Icons.add, color: Colors.white, size: 18),
                    label: const Text(
                      'Analyze New Contract',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.darkBrown,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<AnalysisCubit, AnalysisState>(
                builder: (context, state) {
                  if (state is AnalysisLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is AnalysisError) {
                    return Center(child: Text(state.message));
                  } else if (state is AnalysisHistoryLoaded) {
                    if (state.history.isEmpty) {
                      return const Center(
                        child: Text('No analysis history found.'),
                      );
                    }
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: state.history.length,
                      itemBuilder: (context, index) {
                        final analysis = state.history[index];
                        return AnalysisCard(
                          analysis: analysis,
                          title: 'Contract #${analysis.id}',
                          category: 'Legal',
                          amount: 'N/A',
                          startDate: 'N/A',
                          duration: 'N/A',
                          categoryIcon: Icons.analytics_outlined,
                          riskColor: analysis.riskPercentage > 60
                              ? Colors.red
                              : Colors.green,
                        );
                      },
                    );
                  }
                  return const Center(
                    child: Text('Start scanning documents to see results!'),
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
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, Routes.vault);
          } else if (index == 3) {
            Navigator.pushReplacementNamed(context, Routes.profile);
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

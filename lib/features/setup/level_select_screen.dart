import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/network/app_cubit.dart';

class LevelSelectScreen extends StatefulWidget {
  const LevelSelectScreen({super.key});

  @override
  State<LevelSelectScreen> createState() => _LevelSelectScreenState();
}

class _LevelSelectScreenState extends State<LevelSelectScreen> {
  String _selectedLevel = 'Graduation'; // 'Graduation' or 'UG'

  @override
  Widget build(BuildContext buildContext) {
    final primaryColor = Theme.of(buildContext).primaryColor;
    
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(state.selectedSubExam),
            leading: IconButton(
              icon: const Icon(LucideIcons.arrowLeft),
              onPressed: () => context.read<AppCubit>().goBack(),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Sub-Exam Details Overview Card
                      Card(
                        elevation: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${state.selectedSubExam} Details',
                                style: TextStyle(color: primaryColor, fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'Select your educational qualification tier to load custom tailored study materials and question sets.',
                                style: TextStyle(color: Colors.grey, fontSize: 12, height: 1.5),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),

                      const Text(
                        'Select Level',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),

                      // Graduation vs UG Level Cards
                      Row(
                        children: [
                          Expanded(
                            child: _buildLevelCard(
                              title: 'Graduation',
                              subtitle: "Bachelor's Degree Required",
                              icon: LucideIcons.graduationCap,
                              isSelected: _selectedLevel == 'Graduation',
                              onTap: () => setState(() => _selectedLevel = 'Graduation'),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _buildLevelCard(
                              title: 'UG (Under Graduate)',
                              subtitle: "10+2 Standard Required",
                              icon: LucideIcons.bookOpen,
                              isSelected: _selectedLevel == 'UG',
                              onTap: () => setState(() => _selectedLevel = 'UG'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      const Text(
                        'Statistics Details',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),

                      // Stat cards
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatMiniCard(
                              value: _selectedLevel == 'Graduation' ? '120+' : '100+',
                              label: 'Total Papers',
                              icon: LucideIcons.fileText,
                              color: Colors.indigo,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildStatMiniCard(
                              value: _selectedLevel == 'Graduation' ? '5000+' : '4000+',
                              label: 'Total Questions',
                              icon: LucideIcons.circleHelp,
                              color: Colors.amber[700]!,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildStatMiniCard(
                              value: 'Yes',
                              label: 'AI Organized',
                              icon: LucideIcons.cpu,
                              color: const Color(0xFF10B981),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              // Proceed button
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Update state variables and proceed to Year selection
                    context.read<AppCubit>().selectYear('2023');
                    context.read<AppCubit>().showScreen('YEAR_SELECT');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(56),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Proceed to Year Selection', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLevelCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final primaryColor = Theme.of(context).primaryColor;
    return Card(
      color: isSelected ? primaryColor.withOpacity(0.08) : Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? primaryColor : Colors.grey.withOpacity(0.2),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? primaryColor : Colors.grey, size: 30),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, fontSize: 9),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatMiniCard({
    required String value,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 0.5,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 8, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

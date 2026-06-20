import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/network/app_cubit.dart';
import '../../core/network/exam_db.dart';

class SelectExamScreen extends StatelessWidget {
  const SelectExamScreen({super.key});

  @override
  Widget build(BuildContext buildContext) {
    final primaryColor = Theme.of(buildContext).primaryColor;
    
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        final category = state.selectedCategory;
        final subExams = ExamDb.subExamsData[category] ?? [];

        return Scaffold(
          appBar: AppBar(
            title: Text('${category.toUpperCase()} Exams'),
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
                      Text(
                        'Select $category Sub-Exam',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Select the specific exam you want to practice for',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      const SizedBox(height: 20),

                      // Grid of sub-exams (2-column square cards)
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: subExams.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          childAspectRatio: 1.0,
                        ),
                        itemBuilder: (context, index) {
                          final sub = subExams[index];
                          final isSelected = state.selectedSubExam == sub.name;
                          final List<Color> gradientColors = sub.gradient.map((c) => Color(int.parse(c.replaceAll('#', '0xFF')))).toList();

                          return InkWell(
                            onTap: () {
                              context.read<AppCubit>().selectSubExam(sub.name);
                            },
                            borderRadius: BorderRadius.circular(24),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isSelected ? primaryColor.withOpacity(0.08) : Theme.of(context).cardColor,
                                border: Border.all(
                                  color: isSelected ? primaryColor : Colors.grey.withOpacity(0.2),
                                  width: isSelected ? 2 : 1,
                                ),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: isSelected ? primaryColor : gradientColors[0].withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Icon(
                                      _getIconData(sub.icon),
                                      color: isSelected ? Colors.white : gradientColors[0],
                                      size: 18,
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        sub.name,
                                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
                                      ),
                                      Text(
                                        sub.desc,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(color: Colors.grey, fontSize: 9, fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                      // Optional categories (Graduate/UG level selectors for Railway only)
                      if (category == 'Railway') ...[
                        const SizedBox(height: 32),
                        const Text(
                          'Other Categories',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildOtherCatCard(
                                context: context,
                                title: 'Graduation',
                                icon: LucideIcons.graduationCap,
                                onTap: () {
                                  context.read<AppCubit>().selectSubExam('NTPC');
                                  context.read<AppCubit>().selectYear('2023');
                                  context.read<AppCubit>().showScreen('LEVEL_SELECT');
                                },
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: _buildOtherCatCard(
                                context: context,
                                title: 'UG (Under Graduate)',
                                icon: LucideIcons.bookOpen,
                                onTap: () {
                                  context.read<AppCubit>().selectSubExam('NTPC');
                                  context.read<AppCubit>().selectYear('2023');
                                  context.read<AppCubit>().showScreen('LEVEL_SELECT');
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              
              // Proceed button
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Bypass logic: CGL, CHSL, ALP go directly to Year Selection, NTPC to Level selection
                    if (state.selectedSubExam == 'NTPC') {
                      context.read<AppCubit>().showScreen('LEVEL_SELECT');
                    } else {
                      context.read<AppCubit>().showScreen('YEAR_SELECT');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(56),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Proceed to Setup', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOtherCatCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
          child: Column(
            children: [
              Icon(icon, color: Theme.of(context).primaryColor, size: 24),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconData(String name) {
    switch (name) {
      case 'shieldAlert': return LucideIcons.shieldAlert;
      case 'graduationCap': return LucideIcons.graduationCap;
      case 'shield': return LucideIcons.shield;
      case 'userCheck': return LucideIcons.userCheck;
      case 'settings': return LucideIcons.settings;
      case 'train': return LucideIcons.trainFront;
      case 'users': return LucideIcons.users;
      case 'database': return LucideIcons.database;
      case 'plane': return LucideIcons.plane;
      case 'compass': return LucideIcons.compass;
      case 'activity': return LucideIcons.activity;
      case 'barChart': return LucideIcons.chartBar;
      case 'fileText': return LucideIcons.fileText;
      default: return LucideIcons.file;
    }
  }
}

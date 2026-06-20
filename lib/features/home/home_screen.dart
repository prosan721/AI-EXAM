import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/network/app_cubit.dart';
import '../../core/network/exam_db.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext buildContext) {
    final primaryColor = Theme.of(buildContext).primaryColor;
    final isDark = Theme.of(buildContext).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Banner greeting & theme switcher
          Card(
            color: primaryColor,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Hello, Student 👋',
                          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Let's Crack Your Exam Today!",
                          style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  
                  // Theme switch
                  GestureDetector(
                    onTap: () {
                      buildContext.read<AppCubit>().toggleTheme();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.2)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(isDark ? LucideIcons.sun : LucideIcons.moon, color: Colors.white, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            isDark ? 'Light' : 'Dark',
                            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 28),

          // Exam Categories title
          const Text(
            'Exam Categories',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 14),

          // Categories Grid
          LayoutBuilder(
            builder: (context, constraints) {
              final crossCount = constraints.maxWidth > 600 ? 4 : 2;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: ExamDb.parentCategories.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.5,
                ),
                itemBuilder: (context, index) {
                  final cat = ExamDb.parentCategories[index];
                  final List<Color> gradientColors = cat.gradient.map((c) => Color(int.parse(c.replaceAll('#', '0xFF')))).toList();

                  return InkWell(
                    onTap: () {
                      buildContext.read<AppCubit>().selectCategory(cat.name);
                      buildContext.read<AppCubit>().showScreen('SELECT_EXAM');
                    },
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: gradientColors,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: gradientColors[1].withOpacity(0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            _getIconData(cat.icon),
                            color: Colors.white,
                            size: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cat.name,
                                style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w900),
                              ),
                              Text(
                                cat.desc,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 9, fontWeight: FontWeight.w600),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),

          const SizedBox(height: 32),

          // Quick Access title
          const Text(
            'Quick Access',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 14),

          // Quick Access list
          ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildQuickAccessCard(
                context: buildContext,
                title: 'Previous Year Papers',
                subtitle: 'AI Organized Practice Papers',
                icon: LucideIcons.fileText,
                color: Colors.indigo,
                onTap: () {
                  buildContext.read<AppCubit>().selectCategory('SSC');
                  buildContext.read<AppCubit>().selectSubExam('CGL');
                  buildContext.read<AppCubit>().setPrevPapersTab('uploaded');
                  buildContext.read<AppCubit>().showScreen('PREV_PAPERS');
                },
              ),
              const SizedBox(height: 12),
              _buildQuickAccessCard(
                context: buildContext,
                title: 'Topic-wise Practice',
                subtitle: 'Practice by topic with AI assist',
                icon: LucideIcons.compass,
                color: Colors.amber[700]!,
                onTap: () {
                  buildContext.read<AppCubit>().selectSubject('Math');
                  buildContext.read<AppCubit>().showScreen('SELECT_EXAM'); // goes to setup flow
                },
              ),
              const SizedBox(height: 12),
              _buildQuickAccessCard(
                context: buildContext,
                title: 'AI Bot & Doubts',
                subtitle: 'Ask doubts & generate mock questions',
                icon: LucideIcons.sparkles,
                color: Colors.purple,
                onTap: () {
                  buildContext.read<AppCubit>().showScreen('AI_BOT');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                  ],
                ),
              ),
              const Icon(LucideIcons.chevronRight, color: Colors.grey, size: 18),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconData(String name) {
    switch (name) {
      case 'award': return LucideIcons.award;
      case 'train': return LucideIcons.train;
      case 'plane': return LucideIcons.plane;
      case 'layers': return LucideIcons.layers;
      default: return LucideIcons.award;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/network/app_cubit.dart';
import '../../core/network/exam_db.dart';

class SelectSubjectScreen extends StatelessWidget {
  const SelectSubjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        final selectedSub = state.selectedSubject;
        final topics = ExamDb.topicsData[selectedSub] ?? [];

        return Scaffold(
          appBar: AppBar(
            title: const Text('Smart Practice'),
            leading: IconButton(
              icon: const Icon(LucideIcons.arrowLeft),
              onPressed: () => context.read<AppCubit>().goBack(),
            ),
          ),
          body: Column(
            children: [
              // Subjects list headers
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Subject & Topic',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Choose a subject tab and start practicing specific topics.',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const SizedBox(height: 20),

                    // Horizontal tab row for subjects
                    SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: ExamDb.subjectsData.length,
                        itemBuilder: (context, index) {
                          final sub = ExamDb.subjectsData[index];
                          final isSelected = selectedSub == sub.name;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: FilterChip(
                              label: Text(
                                sub.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? Colors.white : null,
                                ),
                              ),
                              selected: isSelected,
                              onSelected: (_) {
                                context.read<AppCubit>().selectSubject(sub.name);
                              },
                              selectedColor: primaryColor,
                              checkmarkColor: Colors.white,
                              backgroundColor: Theme.of(context).cardColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                                side: BorderSide(
                                  color: isSelected ? Colors.transparent : Colors.grey.withOpacity(0.2),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Topics list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  itemCount: topics.length,
                  itemBuilder: (context, index) {
                    final topic = topics[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12.0),
                      elevation: 0.5,
                      child: ListTile(
                        onTap: () {
                          context.read<AppCubit>().selectTopic(topic.name);
                          context.read<AppCubit>().startPracticeSession();
                        },
                        leading: CircleAvatar(
                          backgroundColor: primaryColor.withOpacity(0.08),
                          child: Icon(LucideIcons.fileQuestion, color: primaryColor, size: 18),
                        ),
                        title: Text(
                          topic.name,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        subtitle: Text(
                          '${topic.count} practice questions available',
                          style: const TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                        trailing: const Icon(LucideIcons.chevronRight, size: 16, color: Colors.grey),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

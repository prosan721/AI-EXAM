import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/network/app_cubit.dart';

class YearSelectScreen extends StatefulWidget {
  const YearSelectScreen({super.key});

  @override
  State<YearSelectScreen> createState() => _YearSelectScreenState();
}

class _YearSelectScreenState extends State<YearSelectScreen> {
  final List<String> _defaultYears = ['2023', '2024', '2025', '2026'];
  late List<String> _years;

  @override
  void initState() {
    super.initState();
    _years = List.from(_defaultYears);
  }

  void _addNewYear() {
    final TextEditingController textController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Custom Year'),
          content: TextField(
            controller: textController,
            keyboardType: TextInputType.number,
            maxLength: 4,
            decoration: const InputDecoration(
              hintText: 'e.g. 2027',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final input = textController.text.trim();
                if (RegExp(r'^\d{4}$').hasMatch(input)) {
                  setState(() {
                    if (!_years.contains(input)) {
                      _years.add(input);
                    }
                  });
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a valid 4-digit year')),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

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
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top sub-exam overview card
                Card(
                  elevation: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${state.selectedSubExam} Overview',
                          style: TextStyle(color: primaryColor, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Practice previous year papers or upload customized PDF papers to organize questions by topic for ${state.selectedSubExam}.',
                          style: const TextStyle(color: Colors.grey, fontSize: 12, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                const Text(
                  'Select Year',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                // Horizontal scrollable years tab bar
                SizedBox(
                  height: 48,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _years.length + 1,
                    itemBuilder: (context, index) {
                      if (index == _years.length) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: OutlinedButton(
                            onPressed: _addNewYear,
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                            ),
                            child: Icon(LucideIcons.plus, color: primaryColor, size: 18),
                          ),
                        );
                      }

                      final year = _years[index];
                      final isSelected = state.selectedYear == year;

                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<AppCubit>().selectYear(year);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSelected ? primaryColor : Theme.of(context).cardColor,
                            foregroundColor: isSelected ? Colors.white : Theme.of(context).textTheme.bodyLarge?.color,
                            elevation: isSelected ? 2 : 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                              side: BorderSide(color: isSelected ? Colors.transparent : Colors.grey.withOpacity(0.2)),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                          ),
                          child: Text(year, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 32),

                const Text(
                  'Available Features',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                // Features list cards
                _buildFeatureCard(
                  title: 'Practice Previous Year Papers',
                  desc: 'Topic-wise organized questions',
                  icon: LucideIcons.fileText,
                  color: Colors.indigo,
                  onTap: () {
                    context.read<AppCubit>().setPrevPapersTab('uploaded');
                    context.read<AppCubit>().showScreen('PREV_PAPERS');
                  },
                ),
                const SizedBox(height: 12),
                _buildFeatureCard(
                  title: 'AI Scan & Organize',
                  desc: 'Upload paper & get AI structured data',
                  icon: LucideIcons.sparkles,
                  color: Colors.purple,
                  onTap: () {
                    context.read<AppCubit>().showScreen('UPLOAD_ORGANIZE');
                  },
                ),
                const SizedBox(height: 12),
                _buildFeatureCard(
                  title: 'Smart Practice',
                  desc: 'Practice topic-wise with instant solution',
                  icon: LucideIcons.zap,
                  color: Colors.amber[700]!,
                  onTap: () {
                    context.read<AppCubit>().showScreen('SELECT_SUBJECT');
                  },
                ),
                const SizedBox(height: 12),
                _buildFeatureCard(
                  title: 'Performance Analysis',
                  desc: 'Track your progress and improve',
                  icon: LucideIcons.chartBar,
                  color: const Color(0xFF10B981),
                  onTap: () {
                    context.read<AppCubit>().showScreen('HOME');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFeatureCard({
    required String title,
    required String desc,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0.5,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      desc,
                      style: const TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                  ],
                ),
              ),
              const Icon(LucideIcons.chevronRight, color: Colors.grey, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

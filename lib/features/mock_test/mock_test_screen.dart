import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../core/network/app_cubit.dart';
import '../../core/network/exam_db.dart';
import '../auth/login_screen.dart';

class MockTestScreen extends StatelessWidget {
  const MockTestScreen({super.key});

  @override
  Widget build(BuildContext buildContext) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        switch (state.activeScreen) {
          case 'PREV_PAPERS':
            return _buildPrevPapersView(context, state);
          case 'MOCK_INFO':
            return _buildMockInfoView(context, state);
          case 'MOCK_SUBJECTS':
            return _buildMockSubjectsView(context, state);
          case 'TEST_VIEW':
            return _buildTestView(context, state);
          case 'TEST_PROGRESS':
            return _buildTestProgressView(context, state);
          case 'REVIEW':
            return _buildReviewView(context, state);
          case 'RESULT':
            return _buildResultView(context, state);
          default:
            return const Scaffold(body: Center(child: Text('Screen not resolved')));
        }
      },
    );
  }

  // --- 1. PREVIOUS PAPERS VIEW ---
  Widget _buildPrevPapersView(BuildContext context, AppState state) {
    final primaryColor = Theme.of(context).primaryColor;
    final isUploaded = state.activePrevPapersTab == 'uploaded';

    return Scaffold(
      appBar: AppBar(
        title: Text('${state.selectedSubExam} Papers'),
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => context.read<AppCubit>().goBack(),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Selection tab buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => context.read<AppCubit>().setPrevPapersTab('uploaded'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isUploaded ? primaryColor : Colors.grey[200],
                          foregroundColor: isUploaded ? Colors.white : Colors.black,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Uploaded Papers', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => context.read<AppCubit>().setPrevPapersTab('mocks'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: !isUploaded ? primaryColor : Colors.grey[200],
                          foregroundColor: !isUploaded ? Colors.white : Colors.black,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Mock Tests', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),

              // Papers List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 100.0),
                  itemCount: isUploaded ? 2 : 2,
                  itemBuilder: (context, index) {
                    final title = isUploaded 
                      ? '${state.selectedSubExam}_${state.selectedYear}_Paper_0${index + 1}.pdf'
                      : '${state.selectedSubExam} Full Length Mock Test ${index + 1}';
                    final sub = isUploaded ? '2.45 MB • 120 Questions' : '10 Questions';

                    return Card(
                      child: InkWell(
                        onTap: () {
                          if (isUploaded) {
                            // goes to mock test instructions
                            context.read<AppCubit>().showScreen('MOCK_INFO');
                          } else {
                            context.read<AppCubit>().startMockTestSession();
                          }
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16.0),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: isUploaded ? Colors.red[50] : primaryColor.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  isUploaded ? LucideIcons.fileText : LucideIcons.sparkles,
                                  color: isUploaded ? Colors.red[700] : primaryColor,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      sub,
                                      style: const TextStyle(color: Colors.grey, fontSize: 10),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isUploaded ? Colors.red[50] : primaryColor.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  isUploaded ? 'PDF' : 'Start',
                                  style: TextStyle(
                                    color: isUploaded ? Colors.red[700] : primaryColor,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          // Floating bottom Mock Test trigger card (only in Uploaded Papers)
          if (isUploaded)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(LucideIcons.sparkles, color: primaryColor, size: 20),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Mock Test (All Papers)',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'AI Organized • Subject Wise',
                              style: TextStyle(color: Colors.grey, fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          context.read<AppCubit>().showScreen('MOCK_INFO');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: const Text('Start Mock', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }

  // --- 2. MOCK TEST INFO VIEW ---
  Widget _buildMockInfoView(BuildContext context, AppState state) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mock Test Info'),
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
                  // Hero Header card
                  Card(
                    color: primaryColor.withOpacity(0.04),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                      side: BorderSide(color: primaryColor.withOpacity(0.15)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(LucideIcons.award, color: primaryColor, size: 24),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${state.selectedSubExam} - ${state.selectedYear} Mock Test',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  'AI Organized • Subject Wise',
                                  style: TextStyle(color: Colors.grey, fontSize: 10),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Stats grid
                  GridView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 2.0,
                    ),
                    children: [
                      _buildMockStatBox('Total Questions', '480'),
                      _buildMockStatBox('Subjects', '6'),
                      _buildMockStatBox('Total Marks', '300'),
                      _buildMockStatBox('Duration', '2:30:00'),
                    ],
                  ),
                  const SizedBox(height: 32),

                  const Text(
                    'Subjects Included',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  // Subjects included list
                  ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildSubjectRow('Mathematics', '30 Questions'),
                      _buildSubjectRow('General Intelligence & Reasoning', '25 Questions'),
                      _buildSubjectRow('General Science', '20 Questions'),
                      _buildSubjectRow('General Awareness', '25 Questions'),
                    ],
                  )
                ],
              ),
            ),
          ),

          // Proceed button
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: () {
                context.read<AppCubit>().showScreen('MOCK_SUBJECTS');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('Start Mock Test', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMockStatBox(String label, String value) {
    return Card(
      elevation: 0.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectRow(String name, String count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          Text(count, style: const TextStyle(color: Colors.grey, fontSize: 11)),
        ],
      ),
    );
  }

  // --- 3. MOCK SUBJECTS / INSTRUCTIONS VIEW ---
  Widget _buildMockSubjectsView(BuildContext context, AppState state) {
    final primaryColor = Theme.of(context).primaryColor;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(state.selectedSubExam),
          leading: IconButton(
            icon: const Icon(LucideIcons.arrowLeft),
            onPressed: () => context.read<AppCubit>().goBack(),
          ),
          bottom: TabBar(
            tabs: const [
              Tab(text: 'Subjects'),
              Tab(text: 'Instructions'),
            ],
            indicatorColor: primaryColor,
            labelColor: primaryColor,
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                children: [
                  // Tab 1: Subjects List
                  ListView(
                    padding: const EdgeInsets.all(20.0),
                    children: [
                      _buildSubjectCard(context, 'Mathematics', '30 Questions', LucideIcons.binary, Colors.amber[700]!),
                      const SizedBox(height: 12),
                      _buildSubjectCard(context, 'General Intelligence & Reasoning', '25 Questions', LucideIcons.brainCircuit, Colors.purple),
                      const SizedBox(height: 12),
                      _buildSubjectCard(context, 'General Science', '20 Questions', LucideIcons.globe, const Color(0xFF10B981)),
                      const SizedBox(height: 12),
                      _buildSubjectCard(context, 'General Awareness', '25 Questions', LucideIcons.shield, Colors.indigo),
                    ],
                  ),

                  // Tab 2: Instructions list
                  ListView(
                    padding: const EdgeInsets.all(20.0),
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Exam Instructions', style: TextStyle(color: primaryColor, fontSize: 15, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 14),
                              const Text('• Please read the questions carefully before selecting an answer.', style: TextStyle(fontSize: 12, height: 1.6)),
                              const SizedBox(height: 8),
                              const Text('• This mock test consists of 10 sample questions representing the real exam standard.', style: TextStyle(fontSize: 12, height: 1.6)),
                              const SizedBox(height: 8),
                              const Text('• Each question carries 2 marks. There is a penalty of 0.5 marks for each incorrect answer.', style: TextStyle(fontSize: 12, height: 1.6)),
                              const SizedBox(height: 8),
                              const Text('• You can review, modify, or clear your choices at any point during the 02:30:00 duration.', style: TextStyle(fontSize: 12, height: 1.6)),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),

            // Start test button
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: () {
                  context.read<AppCubit>().startMockTestSession();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Start Test', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectCard(BuildContext context, String name, String count, IconData icon, Color color) {
    return Card(
      elevation: 0.5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(count, style: const TextStyle(color: Colors.grey, fontSize: 10)),
                ],
              ),
            ),
            const Icon(LucideIcons.chevronRight, color: Colors.grey, size: 16),
          ],
        ),
      ),
    );
  }

  // --- 4. CBT MOCK TEST ENGINE VIEW ---
  Widget _buildTestView(BuildContext context, AppState state) {
    final primaryColor = Theme.of(context).primaryColor;
    final currentQ = state.loadedQuestions[state.currentQuestionIndex];
    final prefixes = ['A', 'B', 'C', 'D'];

    final formatTimer = (int totalSeconds) {
      final hours = totalSeconds ~/ 3600;
      final minutes = (totalSeconds % 3600) ~/ 60;
      final seconds = totalSeconds % 60;
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mock Exam'),
        actions: [
          // Timer badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(LucideIcons.clock, color: primaryColor, size: 13),
                const SizedBox(width: 6),
                Text(
                  formatTimer(state.testTimeRemaining),
                  style: TextStyle(color: primaryColor, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: () {
              context.read<AppCubit>().showScreen('TEST_PROGRESS');
            },
            child: const Text('Submit', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question body card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Q. ${state.currentQuestionIndex + 1}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            currentQ.difficulty,
                            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      currentQ.text,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),

                    // Options cards
                    ...List.generate(currentQ.options.length, (optIdx) {
                      final optText = currentQ.options[optIdx];
                      final isSelected = state.answers[state.currentQuestionIndex] == optIdx;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: InkWell(
                          onTap: () => context.read<AppCubit>().selectOption(optIdx),
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                            decoration: BoxDecoration(
                              color: isSelected ? primaryColor.withOpacity(0.08) : Theme.of(context).cardColor,
                              border: Border.all(
                                color: isSelected ? primaryColor : Colors.grey.withOpacity(0.2),
                                width: isSelected ? 2 : 1,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: isSelected ? primaryColor : Colors.grey[200],
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      prefixes[optIdx],
                                      style: TextStyle(
                                        color: isSelected ? Colors.white : Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Text(
                                  optText,
                                  style: TextStyle(
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Navigation Row buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: state.currentQuestionIndex > 0 
                    ? () => context.read<AppCubit>().setQuestionIndex(state.currentQuestionIndex - 1)
                    : null,
                  icon: const Icon(LucideIcons.chevronLeft, size: 16),
                  label: const Text('Previous', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
                Text(
                  '${state.currentQuestionIndex + 1} / ${state.loadedQuestions.length}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                TextButton(
                  onPressed: state.currentQuestionIndex < state.loadedQuestions.length - 1 
                    ? () => context.read<AppCubit>().setQuestionIndex(state.currentQuestionIndex + 1)
                    : () => context.read<AppCubit>().showScreen('REVIEW'),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        state.currentQuestionIndex < state.loadedQuestions.length - 1 ? 'Next' : 'Review',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 4),
                      const Icon(LucideIcons.chevronRight, size: 16),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Question Palette Grid card drawer
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Question Palette',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 14),

                    // Grid bubbles (10 questions)
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.loadedQuestions.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1.0,
                      ),
                      itemBuilder: (context, idx) {
                        final userAns = state.answers[idx];
                        final isMarked = state.markedQuestions.contains(idx);
                        final isActive = idx == state.currentQuestionIndex;

                        Color bubbleColor = Colors.grey[200]!;
                        Color textColor = Colors.black87;

                        if (isActive) {
                          bubbleColor = primaryColor;
                          textColor = Colors.white;
                        } else if (userAns != null && isMarked) {
                          bubbleColor = Colors.red[100]!; // Review state
                          textColor = Colors.red[700]!;
                        } else if (userAns != null) {
                          bubbleColor = const Color(0xFFD1FAE5); // Answered state
                          textColor = const Color(0xFF065F46);
                        } else if (isMarked) {
                          bubbleColor = Colors.purple[50]!; // Marked state
                          textColor = Colors.purple[700]!;
                        }

                        return InkWell(
                          onTap: () => context.read<AppCubit>().setQuestionIndex(idx),
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: bubbleColor,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isActive ? primaryColor : Colors.grey.withOpacity(0.15),
                                width: isActive ? 2 : 1,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                (idx + 1).toString(),
                                style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),

                    // Legends indicators list
                    const Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      children: [
                        _LegendItem(Color(0xFF10B981), 'Answered'),
                        _LegendItem(Colors.purple, 'Marked'),
                        _LegendItem(Colors.grey, 'Not Answered'),
                        _LegendItem(Colors.red, 'Review'),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Actions buttons row
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => context.read<AppCubit>().toggleBookmark(),
                    icon: Icon(
                      state.markedQuestions.contains(state.currentQuestionIndex) 
                        ? Icons.bookmark 
                        : Icons.bookmark_border,
                      size: 16,
                    ),
                    label: Text(
                      state.markedQuestions.contains(state.currentQuestionIndex) ? 'Unmark' : 'Mark for Review',
                      style: const TextStyle(fontSize: 11),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => context.read<AppCubit>().clearAnswer(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Clear Answer', style: TextStyle(fontSize: 11)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- 5. TEST PROGRESS VIEW ---
  Widget _buildTestProgressView(BuildContext context, AppState state) {
    final primaryColor = Theme.of(context).primaryColor;
    final answered = state.answers.length;
    final marked = state.markedQuestions.length;
    final total = state.loadedQuestions.length;
    final completionPct = total > 0 ? (answered / total) : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Progress'),
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => context.read<AppCubit>().goBack(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Progress Header
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Your Progress', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                Text('Mathematics', style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 32),

            // Semi-circular gauge custom paint or percent indicator
            CircularPercentIndicator(
              radius: 90.0,
              lineWidth: 12.0,
              percent: completionPct,
              center: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${(completionPct * 100).round()}%',
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
                  ),
                  Text(
                    '$answered / $total',
                    style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                  const Text('Completed', style: TextStyle(color: Colors.grey, fontSize: 11)),
                ],
              ),
              circularStrokeCap: CircularStrokeCap.round,
              backgroundColor: Colors.grey.withOpacity(0.1),
              progressColor: primaryColor,
              animation: true,
              animationDuration: 800,
            ),
            const SizedBox(height: 48),

            // Statistics indicators row
            Row(
              children: [
                Expanded(
                  child: _buildProgressStatBox('Answered', answered.toString(), const Color(0xFFD1FAE5), const Color(0xFF065F46)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildProgressStatBox('Marked', marked.toString(), Colors.purple[50]!, Colors.purple[700]!),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildProgressStatBox('Not Answered', (total - answered).toString(), Colors.grey[100]!, Colors.grey[700]!),
                ),
              ],
            ),
            const SizedBox(height: 64),

            ElevatedButton(
              onPressed: () => context.read<AppCubit>().showScreen('REVIEW'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[600],
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('End Test', style: TextStyle(fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildProgressStatBox(String label, String value, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          Text(label, textAlign: TextAlign.center, style: TextStyle(color: textColor.withOpacity(0.8), fontSize: 9, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // --- 6. REVIEW VIEW ---
  Widget _buildReviewView(BuildContext context, AppState state) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Summary'),
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => context.read<AppCubit>().goBack(),
        ),
      ),
      body: Column(
        children: [
          // Filter stats bar
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildReviewStatBadge('All (${state.loadedQuestions.length})', Colors.grey[200]!, Colors.black87),
                _buildReviewStatBadge('Answered (${state.answers.length})', const Color(0xFFD1FAE5), const Color(0xFF065F46)),
                _buildReviewStatBadge('Marked (${state.markedQuestions.length})', Colors.purple[50]!, Colors.purple[700]!),
              ],
            ),
          ),

          // Questions summary list table
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: state.loadedQuestions.length,
              itemBuilder: (context, index) {
                final q = state.loadedQuestions[index];
                final userAns = state.answers[index];
                final isMarked = state.markedQuestions.contains(index);

                String status = 'Not Answered';
                Color statusColor = Colors.grey;

                if (userAns != null && isMarked) {
                  status = 'Review';
                  statusColor = Colors.red;
                } else if (userAns != null) {
                  status = 'Answered';
                  statusColor = const Color(0xFF10B981);
                } else if (isMarked) {
                  status = 'Marked';
                  statusColor = Colors.purple;
                }

                return Card(
                  elevation: 0.5,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: primaryColor.withOpacity(0.08),
                      child: Text(
                        (index + 1).toString(),
                        style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                    title: Text(
                      q.text,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(color: statusColor, fontSize: 9, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Proceed to Submit
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: () {
                _showSubmitConfirmModal(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('Go to Submit', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewStatBadge(String label, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        label,
        style: TextStyle(color: textColor, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _showSubmitConfirmModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (diagContext) {
        return AlertDialog(
          title: const Center(child: Text('Submit Test?')),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(LucideIcons.clipboardList, color: Colors.indigo, size: 48),
              SizedBox(height: 16),
              Text(
                'Are you sure you want to submit the test?',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              SizedBox(height: 4),
              Text(
                'You won\'t be able to change your answers after submission.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 11),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.pop(diagContext),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(diagContext);
                context.read<AppCubit>().evaluateAndShowResults();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Submit Test'),
            ),
          ],
        );
      },
    );
  }

  // --- 7. RESULT VIEW ---
  Widget _buildResultView(BuildContext context, AppState state) {
    final primaryColor = Theme.of(context).primaryColor;
    
    // Evaluate scores
    int correct = 0;
    int incorrect = 0;
    state.answers.forEach((qIdx, ansIdx) {
      if (ansIdx == state.loadedQuestions[qIdx].correctIndex) {
        correct++;
      } else {
        incorrect++;
      }
    });
    final unattempted = state.loadedQuestions.length - state.answers.length;
    final totalMarks = correct * 2 - (incorrect * 0.5); // 2 marks positive, 0.5 negative
    final maxMarks = state.loadedQuestions.length * 2;
    
    final double scorePct = maxMarks > 0 ? (totalMarks / maxMarks) : 0.0;
    final double displayPct = scorePct < 0 ? 0.0 : scorePct;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Result Card'),
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => context.read<AppCubit>().showScreen('HOME'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          width: double.infinity,
          alignment: Alignment.topCenter,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Result Summary', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 28),

                    // Score Circle SVG Animation Gauge
                    CircularPercentIndicator(
                      radius: 80.0,
                      lineWidth: 10.0,
                      percent: displayPct,
                      center: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${totalMarks.toStringAsFixed(1)} / $maxMarks',
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                          ),
                          const SizedBox(height: 2),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD1FAE5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'Good Job!',
                              style: TextStyle(color: Color(0xFF065F46), fontSize: 9, fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      circularStrokeCap: CircularStrokeCap.round,
                      backgroundColor: Colors.grey.withOpacity(0.1),
                      progressColor: const Color(0xFF10B981),
                      animation: true,
                      animationDuration: 1000,
                    ),
                    const SizedBox(height: 32),

                    // Correct/Incorrect/Unattempted breakdown pills
                    Row(
                      children: [
                        Expanded(
                          child: _buildBreakdownPill('Correct', correct.toString(), const Color(0xFF10B981)),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildBreakdownPill('Incorrect', incorrect.toString(), Colors.red),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildBreakdownPill('Unattempted', unattempted.toString(), Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),

                    // Metrics list grid
                    const Divider(),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildMetricBox('Score', '${totalMarks.toStringAsFixed(1)}'),
                        _buildMetricBox('Accuracy', '${(state.answers.isNotEmpty ? (correct / state.answers.length * 100) : 0).round()}%'),
                        _buildMetricBox('Time Taken', '01:05:30'),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 28),

                    // Solution detailed views
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              context.read<AppCubit>().showScreen('TEST_VIEW'); // view solutions mode (mock)
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            child: const Text('View Solutions', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              context.read<AppCubit>().showScreen('HOME');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            child: const Text('Test Analysis', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBreakdownPill(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            '$label: $value',
            style: TextStyle(color: color.withOpacity(0.9), fontSize: 9, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricBox(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem(this.color, this.label);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

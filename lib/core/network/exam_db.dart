import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';

// --- DATA MODELS ---

class ParentCategory {
  final String id;
  final String name;
  final String desc;
  final String icon;
  final List<String> gradient;

  ParentCategory({
    required this.id,
    required this.name,
    required this.desc,
    required this.icon,
    required this.gradient,
  });
}

class SubExam {
  final String id;
  final String name;
  final String desc;
  final String icon;
  final List<String> gradient;

  SubExam({
    required this.id,
    required this.name,
    required this.desc,
    required this.icon,
    required this.gradient,
  });
}

class Subject {
  final String name;
  final String title;
  final String icon;
  final List<String> gradient;

  Subject({
    required this.name,
    required this.title,
    required this.icon,
    required this.gradient,
  });
}

class Topic {
  final String name;
  final int count;

  Topic({
    required this.name,
    required this.count,
  });
}

class Question {
  final int id;
  final String text;
  final List<String> options;
  final int correctIndex;
  int? selectedIndex;
  String status; // 'unattempted', 'answered-correct', 'answered-incorrect', 'marked'
  final String difficulty;
  final String explanationSteps;
  final String correctAnswerLetter;
  final String shortTrick;
  final String concept;
  final Map<String, dynamic>? diagram;

  Question({
    required this.id,
    required this.text,
    required this.options,
    required this.correctIndex,
    this.selectedIndex,
    this.status = 'unattempted',
    required this.difficulty,
    required this.explanationSteps,
    required this.correctAnswerLetter,
    required this.shortTrick,
    required this.concept,
    this.diagram,
  });

  Question copy() {
    return Question(
      id: id,
      text: text,
      options: List.from(options),
      correctIndex: correctIndex,
      selectedIndex: selectedIndex,
      status: status,
      difficulty: difficulty,
      explanationSteps: explanationSteps,
      correctAnswerLetter: correctAnswerLetter,
      shortTrick: shortTrick,
      concept: concept,
      diagram: diagram != null ? Map.from(diagram!) : null,
    );
  }
}

class ScannedPaper {
  final String id;
  final String title;
  final String date;
  final int totalQuestions;
  final Map<String, int> subjectCounts;
  final Map<String, int> topicsBreakdown;
  final List<Question> questions;

  ScannedPaper({
    required this.id,
    required this.title,
    required this.date,
    required this.totalQuestions,
    required this.subjectCounts,
    required this.topicsBreakdown,
    required this.questions,
  });
}

class ExamDb {
  // Static Categories
  static final List<ParentCategory> parentCategories = [
    ParentCategory(
      id: 'SSC',
      name: 'SSC',
      desc: 'Staff Selection Commission',
      icon: 'award',
      gradient: ['#6366F1', '#4F46E5'],
    ),
    ParentCategory(
      id: 'Railway',
      name: 'Railway',
      desc: 'Indian Railways RRB',
      icon: 'train',
      gradient: ['#F59E0B', '#D97706'],
    ),
    ParentCategory(
      id: 'AAI',
      name: 'AAI',
      desc: 'Airports Authority of India',
      icon: 'plane',
      gradient: ['#06B6D4', '#0891B2'],
    ),
    ParentCategory(
      id: 'Other',
      name: 'Other',
      desc: 'Other Competitive Exams',
      icon: 'layers',
      gradient: ['#EC4899', '#DB2777'],
    ),
  ];

  static final Map<String, List<SubExam>> subExamsData = {
    'SSC': [
      SubExam(id: 'cgl', name: 'CGL', desc: 'Combined Graduate Level', icon: 'shieldAlert', gradient: ['#F97316', '#EA580C']),
      SubExam(id: 'chsl', name: 'CHSL', desc: 'Combined Higher Secondary Level', icon: 'graduationCap', gradient: ['#EC4899', '#DB2777']),
      SubExam(id: 'cpo', name: 'CPO', desc: 'Central Police Organization', icon: 'shield', gradient: ['#3B82F6', '#2563EB']),
      SubExam(id: 'mts', name: 'MTS', desc: 'Multi-Tasking Staff', icon: 'userCheck', gradient: ['#8B5CF6', '#7C3AED']),
      SubExam(id: 'je', name: 'JE', desc: 'Junior Engineer', icon: 'settings', gradient: ['#10B981', '#059669']),
    ],
    'Railway': [
      SubExam(id: 'ntpc', name: 'NTPC', desc: 'Non-Technical Popular Categories', icon: 'train', gradient: ['#EC4899', '#F43F5E']),
      SubExam(id: 'group-d', name: 'Group D', desc: 'Railway Group D Entrance', icon: 'users', gradient: ['#F59E0B', '#D97706']),
      SubExam(id: 'alp', name: 'ALP', desc: 'Assistant Loco Pilot', icon: 'train', gradient: ['#10B981', '#059669']),
      SubExam(id: 'rrb-je', name: 'RRB JE', desc: 'Railway Junior Engineer', icon: 'database', gradient: ['#3B82F6', '#2563EB']),
    ],
    'AAI': [
      SubExam(id: 'atc', name: 'ATC', desc: 'Air Traffic Control', icon: 'plane', gradient: ['#06B6D4', '#0891B2']),
      SubExam(id: 'ao', name: 'AO', desc: 'Airport Operations', icon: 'compass', gradient: ['#6366F1', '#4F46E5']),
      SubExam(id: 'common-cadre', name: 'Common Cadre', desc: 'General Operations', icon: 'users', gradient: ['#F43F5E', '#E11D48']),
    ],
    'Other': [
      SubExam(id: 'sbi-po', name: 'SBI PO', desc: 'State Bank of India PO', icon: 'activity', gradient: ['#10B981', '#059669']),
      SubExam(id: 'ibps-po', name: 'IBPS PO', desc: 'Institute of Banking Selection', icon: 'barChart', gradient: ['#8B5CF6', '#7C3AED']),
      SubExam(id: 'wbcs', name: 'WBCS', desc: 'West Bengal Civil Service', icon: 'fileText', gradient: ['#F59E0B', '#D97706']),
    ],
  };

  static final List<Subject> subjectsData = [
    Subject(name: 'Math', title: 'Math', icon: 'binary', gradient: ['#D97706', '#F59E0B']),
    Subject(name: 'English', title: 'English', icon: 'languages', gradient: ['#4F46E5', '#6366F1']),
    Subject(name: 'Reasoning', title: 'Reasoning', icon: 'brainCircuit', gradient: ['#C026D3', '#E879F9']),
    Subject(name: 'GK', title: 'GK', icon: 'globe', gradient: ['#059669', '#10B981']),
  ];

  static final Map<String, List<Topic>> topicsData = {
    'Math': [
      Topic(name: 'Arithmetic', count: 10),
      Topic(name: 'Algebra', count: 8),
      Topic(name: 'Geometry', count: 5),
      Topic(name: 'Number System', count: 3),
      Topic(name: 'Percentage', count: 2),
      Topic(name: 'Profit & Loss', count: 2),
    ],
    'English': [
      Topic(name: 'Grammar Rules', count: 12),
      Topic(name: 'Vocabulary', count: 15),
      Topic(name: 'Reading Comprehension', count: 8),
    ],
    'Reasoning': [
      Topic(name: 'Syllogism', count: 8),
      Topic(name: 'Blood Relations', count: 6),
      Topic(name: 'Coding-Decoding', count: 9),
    ],
    'GK': [
      Topic(name: 'History', count: 15),
      Topic(name: 'Geography', count: 12),
      Topic(name: 'Polity', count: 10),
      Topic(name: 'General Science', count: 14),
    ],
  };

  static final List<Question> defaultQuestions = [
    Question(
      id: 1,
      text: "What is 20% of 150?",
      options: ["20", "25", "30", "35"],
      correctIndex: 2,
      difficulty: 'Medium',
      explanationSteps: "Step 1: Convert percentage to fraction: 20% = 20/100.\nStep 2: Multiply by base: (20/100) * 150 = 30.\nHence, the correct answer is 30.",
      correctAnswerLetter: "C",
      shortTrick: "Trick: 150 ÷ 5 = 30",
      concept: "Percentage is a way of expressing a number as a fraction of 100.\n\n20% = 20/100 = 1/5 = 0.2",
      diagram: {"total": 150, "part": 30, "percent": 20, "label": "30"},
    ),
    Question(
      id: 2,
      text: "What is 25% of 320?",
      options: ["60", "70", "80", "90"],
      correctIndex: 2,
      difficulty: 'Medium',
      explanationSteps: "Step 1: Convert percentage to fraction: 25% = 1/4.\nStep 2: Divide base by 4: 320 / 4 = 80.\nHence, the correct answer is 80.",
      correctAnswerLetter: "C",
      shortTrick: "Trick: 320 ÷ 4 = 80",
      concept: "25% is exactly one quarter.\n\n25% = 25/100 = 1/4 = 0.25",
      diagram: {"total": 320, "part": 80, "percent": 25, "label": "80"},
    ),
    Question(
      id: 3,
      text: "Find 15% of 200.",
      options: ["20", "25", "30", "35"],
      correctIndex: 2,
      difficulty: 'Easy',
      explanationSteps: "Step 1: Convert 15% to decimal: 15% = 0.15.\nStep 2: Multiply: 200 * 0.15 = 30.\nHence, the correct answer is 30.",
      correctAnswerLetter: "C",
      shortTrick: "Trick: 10% (20) + 5% (10) = 30",
      concept: "15% can be computed as 10% plus 5% for faster mental math.\n\n15% = 15/100 = 0.15",
      diagram: {"total": 200, "part": 30, "percent": 15, "label": "30"},
    ),
    Question(
      id: 4,
      text: "What is 40% of 125?",
      options: ["40", "45", "50", "55"],
      correctIndex: 2,
      difficulty: 'Medium',
      explanationSteps: "Step 1: Convert 40% to fraction: 40% = 2/5.\nStep 2: Multiply base: 125 * (2/5) = 50.\nHence, the correct answer is 50.",
      correctAnswerLetter: "C",
      shortTrick: "Trick: (125 * 4) / 10 = 50",
      concept: "40% is equivalent to two-fifths of a number.\n\n40% = 40/100 = 2/5 = 0.4",
      diagram: {"total": 125, "part": 50, "percent": 40, "label": "50"},
    ),
    Question(
      id: 5,
      text: "Find 15% of 240.",
      options: ["36", "40", "45", "48"],
      correctIndex: 0,
      difficulty: 'Easy',
      explanationSteps: "Step 1: Convert 15% to decimal: 15% = 0.15.\nStep 2: Multiply: 240 * 0.15 = 36.\nHence, the correct answer is 36.",
      correctAnswerLetter: "A",
      shortTrick: "Trick: 10% (24) + 5% (12) = 36",
      concept: "15% = 10% + 5%. 24 + 12 = 36.",
      diagram: {"total": 240, "part": 36, "percent": 15, "label": "36"},
    )
  ];

  static List<Question> getFullQuestionsList(String topicName) {
    List<Question> list = defaultQuestions.map((q) => q.copy()).toList();
    for (int i = 6; i <= 25; i++) {
      final total = i * 40;
      final percent = ((i * 3) % 40) + 10;
      final part = ((total * percent) / 100).round();
      final correctIndex = 2; // C is correct
      final options = [
        ((part * 0.8).round()).toString(),
        ((part * 0.9).round()).toString(),
        part.toString(),
        ((part * 1.1).round()).toString(),
      ];
      
      list.push(Question(
        id: i,
        text: "[$topicName] Q.$i: Find $percent% of $total.",
        options: options,
        correctIndex: correctIndex,
        difficulty: i % 3 == 0 ? 'Hard' : (i % 2 == 0 ? 'Easy' : 'Medium'),
        explanationSteps: "Step 1: Convert $percent% to fraction: $percent/100.\nStep 2: Multiply by base: ($percent/100) * $total = $part.",
        correctAnswerLetter: "C",
        shortTrick: "Trick: $total * ${percent / 100} = $part",
        concept: "Basic percentage formula: Part = Total * (Percent / 100).",
        diagram: {"total": total, "part": part, "percent": percent, "label": part.toString()},
      ));
    }
    return list;
  }

  // Scanned papers store
  static final List<ScannedPaper> mockScannedPapers = [
    ScannedPaper(
      id: '1',
      title: 'SSC CGL 2023 Tier 1',
      date: '15 June 2026',
      totalQuestions: 120,
      subjectCounts: {'Math': 30, 'English': 25, 'GK': 35, 'Reasoning': 30},
      topicsBreakdown: {'Arithmetic': 10, 'Algebra': 8, 'Geometry': 5, 'Percentage': 2},
      questions: getFullQuestionsList('Arithmetic'),
    ),
    ScannedPaper(
      id: '2',
      title: 'SSC CHSL 2023 Tier 1',
      date: '10 June 2026',
      totalQuestions: 110,
      subjectCounts: {'Math': 28, 'English': 22, 'GK': 32, 'Reasoning': 28},
      topicsBreakdown: {'Arithmetic': 8, 'Algebra': 6, 'Percentage': 5},
      questions: getFullQuestionsList('Arithmetic'),
    ),
  ];
}

extension ListPush<T> on List<T> {
  void push(T val) => add(val);
}

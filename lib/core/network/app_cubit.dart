import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'exam_db.dart';

// --- APP STATE ---

class AppState {
  final String activeScreen;
  final List<String> history;
  final String? userEmail;
  final String theme; // 'light' or 'dark'
  
  // Selection contexts
  final String selectedCategory;
  final String selectedSubExam;
  final String selectedYear;
  final String selectedSubject;
  final String selectedTopic;
  final String practiceMode; // 'practice' or 'test'
  final String activePrevPapersTab; // 'uploaded' or 'mocks'
  
  // Practice/Test session contexts
  final List<Question> loadedQuestions;
  final int currentQuestionIndex;
  final Map<int, int> answers; // index -> selectedOptionIndex
  final Set<int> markedQuestions; // set of indices
  final int testTimeRemaining;
  final bool isTimerActive;
  
  // Scanned papers database
  final List<ScannedPaper> scannedPapers;
  final bool isScanning;
  final int scanProgress;
  
  // AI Bot contexts
  final List<Map<String, String>> aiChatHistory;
  final List<Question> aiGeneratedQuestions;

  AppState({
    required this.activeScreen,
    required this.history,
    this.userEmail,
    required this.theme,
    required this.selectedCategory,
    required this.selectedSubExam,
    required this.selectedYear,
    required this.selectedSubject,
    required this.selectedTopic,
    required this.practiceMode,
    required this.activePrevPapersTab,
    required this.loadedQuestions,
    required this.currentQuestionIndex,
    required this.answers,
    required this.markedQuestions,
    required this.testTimeRemaining,
    required this.isTimerActive,
    required this.scannedPapers,
    required this.isScanning,
    required this.scanProgress,
    required this.aiChatHistory,
    required this.aiGeneratedQuestions,
  });

  factory AppState.initial() {
    return AppState(
      activeScreen: 'LOGIN',
      history: [],
      userEmail: null,
      theme: 'light',
      selectedCategory: 'SSC',
      selectedSubExam: 'CGL',
      selectedYear: '2023',
      selectedSubject: 'Math',
      selectedTopic: 'Arithmetic',
      practiceMode: 'practice',
      activePrevPapersTab: 'uploaded',
      loadedQuestions: [],
      currentQuestionIndex: 0,
      answers: {},
      markedQuestions: {},
      testTimeRemaining: 600, // 10 minutes default
      isTimerActive: false,
      scannedPapers: List.from(ExamDb.mockScannedPapers),
      isScanning: false,
      scanProgress: 0,
      aiChatHistory: [
        {'sender': 'bot', 'text': 'Hi! I can generate more questions like this for better practice. How many questions do you want?'}
      ],
      aiGeneratedQuestions: [],
    );
  }

  AppState copyWith({
    String? activeScreen,
    List<String>? history,
    String? userEmail,
    String? theme,
    String? selectedCategory,
    String? selectedSubExam,
    String? selectedYear,
    String? selectedSubject,
    String? selectedTopic,
    String? practiceMode,
    String? activePrevPapersTab,
    List<Question>? loadedQuestions,
    int? currentQuestionIndex,
    Map<int, int>? answers,
    Set<int>? markedQuestions,
    int? testTimeRemaining,
    bool? isTimerActive,
    List<ScannedPaper>? scannedPapers,
    bool? isScanning,
    int? scanProgress,
    List<Map<String, String>>? aiChatHistory,
    List<Question>? aiGeneratedQuestions,
  }) {
    return AppState(
      activeScreen: activeScreen ?? this.activeScreen,
      history: history ?? List.from(this.history),
      userEmail: userEmail ?? this.userEmail,
      theme: theme ?? this.theme,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedSubExam: selectedSubExam ?? this.selectedSubExam,
      selectedYear: selectedYear ?? this.selectedYear,
      selectedSubject: selectedSubject ?? this.selectedSubject,
      selectedTopic: selectedTopic ?? this.selectedTopic,
      practiceMode: practiceMode ?? this.practiceMode,
      activePrevPapersTab: activePrevPapersTab ?? this.activePrevPapersTab,
      loadedQuestions: loadedQuestions ?? List.from(this.loadedQuestions),
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      answers: answers ?? Map.from(this.answers),
      markedQuestions: markedQuestions ?? Set.from(this.markedQuestions),
      testTimeRemaining: testTimeRemaining ?? this.testTimeRemaining,
      isTimerActive: isTimerActive ?? this.isTimerActive,
      scannedPapers: scannedPapers ?? List.from(this.scannedPapers),
      isScanning: isScanning ?? this.isScanning,
      scanProgress: scanProgress ?? this.scanProgress,
      aiChatHistory: aiChatHistory ?? List.from(this.aiChatHistory),
      aiGeneratedQuestions: aiGeneratedQuestions ?? List.from(this.aiGeneratedQuestions),
    );
  }
}

// --- APP CUBIT ---

class AppCubit extends Cubit<AppState> {
  Timer? _timer;

  AppCubit() : super(AppState.initial());

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  // Navigation Logic
  void showScreen(String screenId, {bool pushHistory = true}) {
    final List<String> updatedHistory = List.from(state.history);
    if (pushHistory && state.activeScreen != screenId) {
      updatedHistory.add(state.activeScreen);
    }
    emit(state.copyWith(
      activeScreen: screenId,
      history: updatedHistory,
    ));
  }

  void goBack() {
    if (state.history.isNotEmpty) {
      final List<String> updatedHistory = List.from(state.history);
      final String prevScreen = updatedHistory.removeLast();
      
      // Stop timer if exiting active test
      if (state.activeScreen == 'TEST_VIEW' && prevScreen != 'MOCK_SUBJECTS') {
        _timer?.cancel();
      }
      
      emit(state.copyWith(
        activeScreen: prevScreen,
        history: updatedHistory,
        isTimerActive: prevScreen == 'TEST_VIEW' ? state.isTimerActive : false,
      ));
    }
  }

  // Theme Toggler
  void toggleTheme() {
    emit(state.copyWith(theme: state.theme == 'light' ? 'dark' : 'light'));
  }

  // Auth Operations
  void login(String email) {
    emit(state.copyWith(
      userEmail: email,
      activeScreen: 'HOME',
    ));
  }

  void logout() {
    _timer?.cancel();
    emit(AppState.initial());
  }

  // Category and Exam Selection
  void selectCategory(String category) {
    final subExams = ExamDb.subExamsData[category] ?? [];
    final firstSub = subExams.isNotEmpty ? subExams[0].name : '';
    emit(state.copyWith(
      selectedCategory: category,
      selectedSubExam: firstSub,
    ));
  }

  void selectSubExam(String subExam) {
    emit(state.copyWith(selectedSubExam: subExam));
  }

  void selectYear(String year) {
    emit(state.copyWith(selectedYear: year));
  }

  void selectSubject(String subject) {
    emit(state.copyWith(selectedSubject: subject));
  }

  void selectTopic(String topic) {
    emit(state.copyWith(selectedTopic: topic));
  }

  void setPracticeMode(String mode) {
    emit(state.copyWith(practiceMode: mode));
  }

  void setPrevPapersTab(String tab) {
    emit(state.copyWith(activePrevPapersTab: tab));
  }

  // Scanner Simulator
  void startPdfScanning(String fileName) {
    emit(state.copyWith(
      isScanning: true,
      scanProgress: 0,
      activeScreen: 'UPLOAD_ORGANIZE',
    ));

    Timer.periodic(const Duration(milliseconds: 150), (timer) {
      final int nextProgress = state.scanProgress + 8;
      if (nextProgress >= 100) {
        timer.cancel();
        emit(state.copyWith(
          scanProgress: 100,
          isScanning: false,
        ));
        Future.delayed(const Duration(milliseconds: 500), () {
          emit(state.copyWith(activeScreen: 'UPLOAD_SUMMARY'));
        });
      } else {
        emit(state.copyWith(scanProgress: nextProgress));
      }
    });
  }

  void saveScannedPaper() {
    final nextId = (state.scannedPapers.length + 1).toString();
    final newPaper = ScannedPaper(
      id: nextId,
      title: '${state.selectedSubExam} Mock Paper #$nextId (AI Organised)',
      date: 'Today',
      totalQuestions: 120,
      subjectCounts: {'Math': 30, 'English': 25, 'GK': 35, 'Reasoning': 30},
      topicsBreakdown: {'Arithmetic': 10, 'Algebra': 8, 'Geometry': 5, 'Percentage': 2},
      questions: ExamDb.getFullQuestionsList('Arithmetic'),
    );

    emit(state.copyWith(
      scannedPapers: [newPaper, ...state.scannedPapers],
      activeScreen: 'PREV_PAPERS',
    ));
  }

  // Quiz / Mock Test Engine Logic
  void startPracticeSession() {
    final questions = ExamDb.getFullQuestionsList(state.selectedTopic);
    emit(state.copyWith(
      loadedQuestions: questions,
      currentQuestionIndex: 0,
      answers: {},
      markedQuestions: {},
      practiceMode: 'practice',
      activeScreen: 'TEST_VIEW',
    ));
  }

  void startMockTestSession() {
    _timer?.cancel();
    final questions = ExamDb.getFullQuestionsList('Arithmetic').sublist(0, 10);
    emit(state.copyWith(
      loadedQuestions: questions,
      currentQuestionIndex: 0,
      answers: {},
      markedQuestions: {},
      practiceMode: 'test',
      testTimeRemaining: 9000, // 2h 30m
      isTimerActive: true,
      activeScreen: 'TEST_VIEW',
    ));

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.testTimeRemaining <= 0) {
        timer.cancel();
        evaluateAndShowResults();
      } else {
        emit(state.copyWith(testTimeRemaining: state.testTimeRemaining - 1));
      }
    });
  }

  void selectOption(int optIdx) {
    final Map<int, int> updatedAnswers = Map.from(state.answers);
    
    // Toggle check
    if (updatedAnswers[state.currentQuestionIndex] == optIdx) {
      updatedAnswers.remove(state.currentQuestionIndex);
    } else {
      updatedAnswers[state.currentQuestionIndex] = optIdx;
    }

    emit(state.copyWith(answers: updatedAnswers));
  }

  void toggleBookmark() {
    final Set<int> updatedMarked = Set.from(state.markedQuestions);
    final idx = state.currentQuestionIndex;
    if (updatedMarked.contains(idx)) {
      updatedMarked.remove(idx);
    } else {
      updatedMarked.add(idx);
    }
    emit(state.copyWith(markedQuestions: updatedMarked));
  }

  void clearAnswer() {
    final Map<int, int> updatedAnswers = Map.from(state.answers);
    updatedAnswers.remove(state.currentQuestionIndex);
    emit(state.copyWith(answers: updatedAnswers));
  }

  void setQuestionIndex(int index) {
    if (index >= 0 && index < state.loadedQuestions.length) {
      emit(state.copyWith(currentQuestionIndex: index));
    }
  }

  void evaluateAndShowResults() {
    _timer?.cancel();
    emit(state.copyWith(
      isTimerActive: false,
      activeScreen: 'RESULT',
    ));
  }

  // AI Doubt Solver Bot Logic
  void sendChatMessage(String messageText) {
    final List<Map<String, String>> updatedChat = List.from(state.aiChatHistory);
    updatedChat.add({'sender': 'user', 'text': messageText});
    emit(state.copyWith(aiChatHistory: updatedChat));

    // Simulated Bot Reply
    Timer(const Duration(milliseconds: 1000), () {
      final String lower = messageText.toLowerCase();
      String reply = '';

      if (lower.contains('question') || lower.contains('generate') || lower.contains('practice')) {
        int count = 10;
        if (lower.contains('30')) count = 30;
        if (lower.contains('40')) count = 40;
        
        reply = 'Generating $count questions on topics related to Percentage & Arithmetic for you. Click below to view them!';
        
        // Generate mockup AI questions
        final generated = <Question>[];
        for (int i = 0; i < count; i++) {
          final val = 100 + (i * 20);
          final pct = 10 + (i * 5);
          final ans = ((pct / 100) * val).round();
          generated.add(Question(
            id: 100 + i,
            text: 'What is $pct% of $val?',
            options: ['${ans - 10}', '${ans - 5}', '$ans', '${ans + 5}'],
            correctIndex: 2,
            difficulty: i % 3 == 0 ? 'Hard' : (i % 2 == 0 ? 'Easy' : 'Medium'),
            explanationSteps: 'Step 1: convert $pct% to decimal: ${pct/100}.\nStep 2: Multiply by base: ${pct/100} * $val = $ans.',
            correctAnswerLetter: 'C',
            shortTrick: 'Trick: decimal fraction math.',
            concept: 'Percentage is a way of expressing a number as a fraction of 100.',
          ));
        }

        updatedChat.add({'sender': 'bot', 'text': reply});
        emit(state.copyWith(
          aiChatHistory: updatedChat,
          aiGeneratedQuestions: generated,
        ));
      } else {
        final generalReplies = [
          "I can help you create custom practice question sets. Try selecting '30 Questions' or type 'generate 10 algebra questions'.",
          "EXAM.AI provides mock tests and interactive explanation analysis. Feel free to ask any doubt about calculations!",
          "To solve percentages quickly, remember to divide the number by 5 to calculate 20% immediately."
        ];
        reply = generalReplies[DateTime.now().millisecond % generalReplies.length];
        updatedChat.add({'sender': 'bot', 'text': reply});
        emit(state.copyWith(aiChatHistory: updatedChat));
      }
    });
  }

  void loadAiQuestionsAndStart() {
    emit(state.copyWith(
      loadedQuestions: state.aiGeneratedQuestions,
      currentQuestionIndex: 0,
      answers: {},
      markedQuestions: {},
      practiceMode: 'practice',
      activeScreen: 'TEST_VIEW',
    ));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/network/app_cubit.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/login_screen.dart';
import 'features/home/home_screen.dart';
import 'features/setup/select_exam_screen.dart';
import 'features/setup/level_select_screen.dart';
import 'features/setup/year_select_screen.dart';
import 'features/setup/select_subject_screen.dart';
import 'features/scanner/upload_organize_screen.dart';
import 'features/mock_test/mock_test_screen.dart';
import 'features/home/ai_bot_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint("Firebase initialization failed: $e");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppCubit(),
      child: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'EXAM.AI',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state.theme == 'light' ? ThemeMode.light : ThemeMode.dark,
            home: const AppContentWrapper(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

class AppContentWrapper extends StatelessWidget {
  const AppContentWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        switch (state.activeScreen) {
          case 'LOGIN':
            return const LoginScreen();
          case 'HOME':
            return const Scaffold(
              body: SafeArea(
                child: HomeScreen(),
              ),
            );
          case 'SELECT_EXAM':
            return const SelectExamScreen();
          case 'LEVEL_SELECT':
            return const LevelSelectScreen();
          case 'YEAR_SELECT':
            return const YearSelectScreen();
          case 'SELECT_SUBJECT':
            return const SelectSubjectScreen();
          case 'UPLOAD_ORGANIZE':
          case 'UPLOAD_SUMMARY':
            return const UploadOrganizeScreen();
          case 'PREV_PAPERS':
          case 'MOCK_INFO':
          case 'MOCK_SUBJECTS':
          case 'TEST_VIEW':
          case 'TEST_PROGRESS':
          case 'REVIEW':
          case 'RESULT':
            return const MockTestScreen();
          case 'AI_BOT':
            return const AiBotScreen();
          default:
            return const Scaffold(
              body: Center(
                child: Text('Screen not resolved'),
              ),
            );
        }
      },
    );
  }
}

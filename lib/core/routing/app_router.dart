import 'package:biblia_ar_flutter/core/routing/route_names.dart';
import 'package:biblia_ar_flutter/features/activities/activities_hub_screen.dart';
import 'package:biblia_ar_flutter/features/home/home_screen.dart';
import 'package:biblia_ar_flutter/features/lesson/lesson_player_screen.dart';
import 'package:biblia_ar_flutter/features/profiles/create_profile_screen.dart';
import 'package:biblia_ar_flutter/features/profiles/profile_selection_screen.dart';
import 'package:biblia_ar_flutter/features/progress/progress_screen.dart';
import 'package:biblia_ar_flutter/features/settings/settings_screen.dart';
import 'package:biblia_ar_flutter/features/splash/splash_screen.dart';
import 'package:biblia_ar_flutter/features/teacher/teacher_screen.dart';
import 'package:flutter/material.dart';

// kguanoluisa, Enrutador central con navegacion jerarquica de maximo dos niveles, sin nuevas variables, 2026-07-23
class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case RouteNames.profiles:
        return MaterialPageRoute(builder: (_) => const ProfileSelectionScreen());
      case RouteNames.createProfile:
        return MaterialPageRoute(builder: (_) => const CreateProfileScreen());
      case RouteNames.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case RouteNames.lesson:
        return MaterialPageRoute(builder: (_) => const LessonPlayerScreen());
      case RouteNames.activities:
        return MaterialPageRoute(builder: (_) => const ActivitiesHubScreen());
      case RouteNames.settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case RouteNames.progress:
        return MaterialPageRoute(builder: (_) => const ProgressScreen());
      case RouteNames.teacher:
        return MaterialPageRoute(builder: (_) => const TeacherScreen());
      default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }
}

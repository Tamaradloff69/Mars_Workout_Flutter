import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mars_workout_app/core/theme/app_theme.dart';
import 'package:mars_workout_app/presentation/screens/home_screen/home_page.dart';
import 'package:path_provider/path_provider.dart';
import '../../logic/bloc/plan/plan_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PlanBloc(),
      child: MaterialApp(
        title: 'Workout Planner',
        darkTheme: AppTheme.lightTheme,
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        home: const HomePage(),
        // Define your routes for timer/details here...
      ),
    );
  }
}
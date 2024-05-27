import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_rv/Infrastructure/apis/cloud.dart';
import 'package:task_manager_rv/Infrastructure/auth/auth_service.dart';
import 'package:task_manager_rv/Infrastructure/db/db_service.dart';
import 'package:task_manager_rv/application/auth/auth_bloc.dart';
import 'package:task_manager_rv/application/login/login_bloc.dart';
import 'package:task_manager_rv/application/notes/note_add/add_bloc.dart';
import 'package:task_manager_rv/application/notes/note_delete/delete_bloc.dart';
import 'package:task_manager_rv/application/notes/note_edit/edit_bloc.dart';
import 'package:task_manager_rv/application/registration/register_bloc.dart';
import 'package:task_manager_rv/core/common/connectivity.dart';

import 'package:task_manager_rv/presentation/splash/screen_splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: options);

  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  final FirebaseDbService firebaseDbService = FirebaseDbService();
  final ConnectivityService connectivityService = ConnectivityService();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
        create: (context) => AuthBloc(),
      ),
      BlocProvider(
        create: (context) => LoginBloc(FirebaseAuthService()),
      ),
      BlocProvider(
        create: (context) => AddBloc(firebaseDbService,connectivityService),
      ),
      BlocProvider(
        create: (context) => EditBloc(firebaseDbService,connectivityService),
      ),
      BlocProvider(
        create: (context) => DeleteBloc(firebaseDbService,connectivityService),
        child: Container(),
      ),
      BlocProvider(
        create: (context) => RegisterBloc(FirebaseAuthService(),connectivityService),
      )
    ], child: const MaterialApp(
      debugShowCheckedModeBanner: false,
      
      home: Screensplash()));
  }
}

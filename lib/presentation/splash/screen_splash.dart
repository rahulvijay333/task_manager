import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_rv/application/auth/auth_bloc.dart';
import 'package:task_manager_rv/core/constants/constants.dart';
import 'package:task_manager_rv/presentation/home/screen_home.dart';
import 'package:task_manager_rv/presentation/login/screen_login.dart';

class Screensplash extends StatefulWidget {
  const Screensplash({super.key});

  @override
  State<Screensplash> createState() => _ScreensplashState();
}

class _ScreensplashState extends State<Screensplash> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(
      const Duration(seconds: 4),
      () {
        BlocProvider.of<AuthBloc>(context).add(CheckAuthStatus());
        final authBloc = BlocProvider.of<AuthBloc>(context);

        authBloc.stream.listen((state) {
          if (state is AuthSuccess) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) {
                return ScreenHome(
                  userId: state.userId,
                );
              },
            ));
          } else if (state is AuthFailed) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) {
                return ScreenLogin();
              },
            ));
          }
        });
      },
    );

    return const Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Task Manager App',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w400)),
            Text(' by Rahul Vijay',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w200)),
            space15,
            Center(
              child: CircularProgressIndicator(
                strokeWidth: 1,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}

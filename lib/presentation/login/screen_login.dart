import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_rv/application/login/login_bloc.dart';
import 'package:task_manager_rv/core/constants/constants.dart';
import 'package:task_manager_rv/presentation/home/screen_home.dart';
import 'package:task_manager_rv/presentation/register/screen_register.dart';

class ScreenLogin extends StatelessWidget {
  ScreenLogin({super.key});

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Login',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) {
                return ScreenHome(
                  userId: state.userData.uid,
                );
              },
            ));
          } else if (state is LoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.showError),
              duration: const Duration(seconds: 2),
            ));
          }
        },
        child: LoginPageWidget(
            size: size,
            emailController: _emailController,
            passwordController: _passwordController),
      ),
    );
  }
}

class LoginPageWidget extends StatelessWidget {
  const LoginPageWidget({
    super.key,
    required this.size,
    required TextEditingController emailController,
    required TextEditingController passwordController,
  })  : _emailController = emailController,
        _passwordController = passwordController;

  final Size size;
  final TextEditingController _emailController;
  final TextEditingController _passwordController;

  void login(
      {required String email,
      required String password,
      required BuildContext context}) {
    if (email.isNotEmpty && password.isNotEmpty) {
      BlocProvider.of<LoginBloc>(context)
          .add(LoginUsingEmail(username: email, password: password));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all the credentials')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        height: size.height,
        width: size.width,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const IntroWidget(),
              const SizedBox(
                height: 15,
              ),
              Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Email Address',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 5),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5)),
                      child: TextFormField(
                        cursorColor: Colors.blue,
                        controller: _emailController,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.grey),
                            hintText: 'Enter your email'),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      'Password',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 5),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5)),
                      child: TextFormField(
                        obscureText: true,
                        cursorColor: Colors.blue,
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.grey),
                            hintText: 'Enter your password'),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () {
                        login(
                            email: _emailController.text,
                            password: _passwordController.text,
                            context: context);
                      },
                      child: Container(
                        width: size.width,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(5)),
                        child: Center(child: BlocBuilder<LoginBloc, LoginState>(
                          builder: (context, state) {
                            if (state is LoginLoading) {
                              return const SizedBox(
                                width: 25,
                                height: 25,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              );
                            }

                            return const Text(
                              'Login',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            );
                          },
                        )),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Dont have an account ? '),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) {
                          return const ScreenRegister();
                        },
                      ));
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}

class IntroWidget extends StatelessWidget {
  const IntroWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: SizedBox(
            width: 150,
            height: 150,
            child: Image.asset('assets/login_page_logo.png'),
          ),
        ),
        const Text(
          'Hello, Welcome Back',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const Text(
          'Easy manage your tasks',
          style: TextStyle(color: Colors.grey),
        ),
        space15
      ],
    );
  }
}

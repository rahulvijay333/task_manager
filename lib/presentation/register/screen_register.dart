import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_rv/application/registration/register_bloc.dart';
import 'package:task_manager_rv/core/constants/constants.dart';
import 'package:task_manager_rv/presentation/login/screen_login.dart';

class ScreenRegister extends StatefulWidget {
  const ScreenRegister({super.key});

  @override
  State<ScreenRegister> createState() => _ScreenRegisterState();
}

class _ScreenRegisterState extends State<ScreenRegister> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  bool emailError = false;
  bool passwordError = false;
  bool nameError = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return WillPopScope(
      onWillPop: () async {
        final leave = await showLeaveRegistDialoge();
        if (leave == true) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => ScreenLogin(),
          ));

          return false;
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          title: const Text(
            'Register',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            height: size.height,
            width: size.width,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Center(
                      child: Image.asset(
                    'assets/register_logo.png',
                    width: 250,
                    height: 250,
                  )),
                  const SizedBox(
                    height: 15,
                  ),
                  Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Full Name',
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
                            controller: fullNameController,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintStyle: TextStyle(color: Colors.grey),
                                hintText: 'Enter your name'),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                          child: nameError
                              ? const Text(
                                  'name required',
                                  style: TextStyle(color: Colors.red),
                                )
                              : null,
                        ),
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
                            controller: emailController,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintStyle: TextStyle(color: Colors.grey),
                                hintText: 'Enter your email'),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                          child: emailError
                              ? const Text(
                                  'email required',
                                  style: TextStyle(color: Colors.red),
                                )
                              : null,
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
                            controller: passwordController,
                            cursorColor: Colors.blue,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintStyle: TextStyle(color: Colors.grey),
                                hintText: 'Enter your password'),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                          child: passwordError
                              ? const Text(
                                  'password required',
                                  style: TextStyle(color: Colors.red),
                                )
                              : null,
                        ),
                        space10,
                        GestureDetector(
                          onTap: () {
                            if (checkValidation()) {
                              //------------------------------------------------call register bloc
                              BlocProvider.of<RegisterBloc>(context).add(
                                  RegisterNewUser(
                                      email: emailController.text,
                                      password: passwordController.text.trim(),
                                      fullname: fullNameController.text));
                            }
                          },
                          child: Container(
                            width: size.width,
                            height: 50,
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(5)),
                            child: Center(
                                child:
                                    BlocConsumer<RegisterBloc, RegisterState>(
                              listener: (context, state) {
                                if (state is RegisterSuccess) {
                                  Navigator.of(context)
                                      .pushReplacement(MaterialPageRoute(
                                    builder: (context) {
                                      return ScreenLogin();
                                    },
                                  ));
                                } else if (state is RegisterFailed) {
                                  //-----------------------------------------------show error message
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          duration: const Duration(seconds: 3),
                                          behavior: SnackBarBehavior.floating,
                                          margin: EdgeInsets.only(
                                              bottom: size.height * 0.02,
                                              left: 25,
                                              right: 25),
                                          content:
                                              Text(state.showErrorMessage)));
                                }
                              },
                              builder: (context, state) {
                                if (state is RegisterLoading) {
                                  return const SizedBox(
                                    height: 25,
                                    width: 25,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 1,
                                    ),
                                  );
                                }

                                return const Text(
                                  'Register',
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool?> showLeaveRegistDialoge() => showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('leave registration'),
            content: const Text('Are you sure ?'),
            actions: [
              TextButton(
                  onPressed: () {
                    return Navigator.pop(context, false);
                  },
                  child: const Text(
                    'cancel',
                    style: TextStyle(color: Colors.blue),
                  )),
              TextButton(
                  onPressed: () {
                    return Navigator.pop(context, true);
                  },
                  child: const Text(
                    'ok',
                    style: TextStyle(color: Colors.blue),
                  ))
            ],
          );
        },
      );

  bool checkValidation() {
    if (fullNameController.text.isEmpty) {
      setState(() {
        nameError = true;
      });
    } else {
      setState(() {
        nameError = false;
      });
    }
    if (emailController.text.isEmpty) {
      setState(() {
        emailError = true;
      });
    } else {
      setState(() {
        emailError = false;
      });
    }
    if (passwordController.text.isEmpty) {
      setState(() {
        passwordError = true;
      });
    } else {
      setState(() {
        passwordError = false;
      });
    }

    if (fullNameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      setState(() {
        emailError = false;
        passwordError = false;
        nameError = false;
      });

      return true;
    } else {
      return false;
    }
  }
}

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_rv/Infrastructure/db/db_service.dart';
import 'package:task_manager_rv/application/auth/auth_bloc.dart';
import 'package:task_manager_rv/application/notes/note_delete/delete_bloc.dart';
import 'package:task_manager_rv/core/constants/constants.dart';
import 'package:task_manager_rv/core/datetime/datime.dart';
import 'package:task_manager_rv/domain/task_model.dart';
import 'package:task_manager_rv/presentation/home/widgets/screen_note_edit.dart';
import 'package:task_manager_rv/presentation/login/screen_login.dart';
import 'package:task_manager_rv/presentation/note_op/screen_note.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    //----------------------------------------------------------monitor auth status
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailed) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) {
              return ScreenLogin();
            },
          ));
        }
      },
      child: WillPopScope(
        onWillPop: () async {
          final leaveApp = await showLeaveAppDialoge(context);

          return leaveApp ?? false;
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Task Manager',
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
            backgroundColor: Colors.blue,
            actions: [
              IconButton(
                  onPressed: () async {
                    //-----------------------------------------show user logout dialog
                    showLogoutDialog(context);
                  },
                  icon: const Icon(
                    Icons.logout,
                    color: Colors.white,
                  ))
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.blue,
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return ScreenNote(
                    userId: userId,
                  );
                },
              ));
            },
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: StreamBuilder(
              stream: FirebaseDbService().getAllTasks(userId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isEmpty) {
                    return BlocListener<DeleteBloc, DeleteState>(
                      listener: (context, state) {
                          if (state is DeleteNoteSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsets.only(
                          bottom: size.height * 0.01, left: 25, right: 25),
                      content: const Text('note deleted')));
                } else if (state is DeleteNoteFailed) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      duration: const Duration(seconds: 3),
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsets.only(
                          bottom: size.height * 0.02, left: 25, right: 25),
                      content: Text(state.errorMessage)));
                }
                      },
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/no_data.png'),
                            const Text('No Tasks'),
                          ],
                        ),
                      ),
                    );
                  }
                  final data = snapshot.data;
                  return ListView.separated(
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) {
                                return ScreenNoteEdit(
                                  taskModel: data[index],
                                  userId: userId,
                                );
                              },
                            ));
                          },
                          child: TaskTileWidget(
                            size: size,
                            data: data!,
                            index: index,
                            userID: userId,
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(
                            height: 10,
                          ),
                      itemCount: snapshot.data!.length);
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text('Please try lator'),
                  );
                } else {
                  return const Center(
                    child: Text('No data'),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<bool?> showLeaveAppDialoge(BuildContext context) => showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Leave App'),
            content: const Text('are you sure ?'),
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
}

Future<dynamic> showLogoutDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure ?'),
        actions: [
          TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) Navigator.of(context).pop();
                context.mounted
                    ? BlocProvider.of<AuthBloc>(context).add(CheckAuthStatus())
                    : null;
              },
              child: const Text(
                'yes',
                style: TextStyle(color: Colors.black),
              )),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'No',
                style: TextStyle(color: Colors.black),
              ))
        ],
      );
    },
  );
}

class TaskTileWidget extends StatelessWidget {
  const TaskTileWidget({
    super.key,
    required this.size,
    required this.data,
    required this.index,
    required this.userID,
  });

  final Size size;
  final List<TaskModel> data;
  final int index;
  final String userID;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 3.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 0.5),
          borderRadius: BorderRadius.circular(10)),
      width: size.width * 0.85,
      // height: size.height * 0.20,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        //--------------------------------------------------
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data[index].title,
              style: Theme.of(context).textTheme.titleLarge,
              overflow: TextOverflow.ellipsis,
            ),
            space5,
            Text(
                DataTimeFunction()
                    .getFormattedDateTime(data[index].dueDateTime),
                style: const TextStyle(color: Colors.black)),
            space10,
            Text(data[index].description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyLarge),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 5, bottom: 5),
                  decoration: BoxDecoration(
                      color: data[index].taskStatus
                          ? Colors.green.shade100
                          : Colors.red.shade100,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                          color: data[index].taskStatus
                              ? Colors.green
                              : Colors.red)),
                  child: Row(
                    children: [
                      const Text('status : '),
                      Text(data[index].taskStatus ? 'Completed' : 'Pending')
                    ],
                  ),
                ),
                const Spacer(),
                BlocListener<DeleteBloc, DeleteState>(
                  listener: (context, state) {
                    if (state is DeleteNoteSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          duration: const Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.only(
                              bottom: size.height * 0.02, left: 25, right: 25),
                          content: const Text('note deleted')));
                    } else if (state is DeleteNoteFailed) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          duration: const Duration(seconds: 3),
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.only(
                              bottom: size.height * 0.02, left: 25, right: 25),
                          content: Text(state.errorMessage)));
                    }
                  },
                  child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () async {
                        BlocProvider.of<DeleteBloc>(context).add(
                            DeleteNoteEvent(
                                id: data[index].id, userID: userID));
                      },
                      icon: const Icon(Icons.delete)),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

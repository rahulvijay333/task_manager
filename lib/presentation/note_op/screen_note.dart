import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_manager_rv/application/notes/note_add/add_bloc.dart';
import 'package:task_manager_rv/core/common/connectivity.dart';
import 'package:task_manager_rv/core/datetime/datime.dart';
import 'package:task_manager_rv/domain/task_model.dart';
import 'package:uuid/uuid.dart';

class ScreenNote extends StatefulWidget {
  const ScreenNote({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  State<ScreenNote> createState() => _ScreenNoteState();
}

class _ScreenNoteState extends State<ScreenNote> {
  final GlobalKey<_DeadLineWidgetState> deadlineKey =
      GlobalKey<_DeadLineWidgetState>();

  final titleController = TextEditingController();

  final descriptionController = TextEditingController();

  final timeTakenController = TextEditingController();

  bool leaveTaskPage = false;

  addNote({required TaskModel task, required BuildContext context}) {
    BlocProvider.of<AddBloc>(context)
        .add(AddNoteEevent(task: task, userID: widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return WillPopScope(
      onWillPop: () async {
        final shouldpop = await showLeavePageDialoge();

        return shouldpop ?? false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blue,
          title: const Text(
            'New Task',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(1),
                  child: TextFormField(
                    cursorColor: Colors.blue,
                    controller: titleController,
                    maxLines: null,
                    decoration: const InputDecoration(
                        hintStyle: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.w400),
                        border: InputBorder.none,
                        suffixIcon: Icon(
                          Icons.edit,
                          color: Colors.grey,
                        ),
                        hintText: 'Enter Title'),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  padding: const EdgeInsets.all(1),
                  child: TextFormField(
                    cursorColor: Colors.blue,
                    controller: descriptionController,
                    maxLines: 20,
                    minLines: 1,
                    decoration: const InputDecoration(
                        hintStyle: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.w400),
                        border: InputBorder.none,
                        suffixIcon: Icon(
                          Icons.edit,
                          color: Colors.grey,
                        ),
                        hintText: 'Add description'),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(1),
                  child: TextFormField(
                    cursorColor: Colors.blue,
                    controller: timeTakenController,
                    maxLines: 1,
                    maxLength: 20,
                    decoration: const InputDecoration(
                        hintStyle: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.w400),
                        border: InputBorder.none,
                        counterText: '',
                        suffixIcon: Icon(
                          Icons.edit,
                          color: Colors.grey,
                        ),
                        hintText: 'Estimated time to complete'),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.blue)),
                  child: DeadLineWidget(
                    key: deadlineKey,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: () async {
                    if (titleController.text.isNotEmpty &&
                        descriptionController.text.isNotEmpty &&
                        timeTakenController.text.isNotEmpty &&
                        deadlineKey.currentState!.formatedTime != null) {
                      var uuid = const Uuid();
                      final datetime = DataTimeFunction().join(
                          deadlineKey.currentState!.selectedDate,
                          deadlineKey.currentState!.formatedTime!);
                      final task = TaskModel(
                          id: uuid.v1(),
                          title: titleController.text,
                          description: descriptionController.text,
                          estimatedTime: timeTakenController.text,
                          dueDateTime: datetime,
                          taskStatus: deadlineKey.currentState!.taskStatus);
                      //-----------------------------save note function

                      addNote(task: task, context: context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          duration: const Duration(seconds: 3),
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.only(
                              bottom: size.height * 0.02, left: 25, right: 25),
                          content: const Text('Please fill all values')));
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8)),
                    width: size.width * 0.35,
                    height: 45,
                    child: Center(
                        child: BlocConsumer<AddBloc, AddState>(
                      listener: (context, state) {
                        if (state is AddNoteSuccess) {
                          Navigator.of(context).pop();
                        } else if (state is AddNoteFailed) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              duration: const Duration(seconds: 3),
                              behavior: SnackBarBehavior.floating,
                              margin: EdgeInsets.only(
                                  bottom: size.height * 0.02,
                                  left: 25,
                                  right: 25),
                              content: Text(state.errorMessage)));
                        }
                      },
                      builder: (context, state) {
                        if (state is AddnoteLoading) {
                          return const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 1,
                                color: Colors.white,
                              ));
                        }
                        return const Text(
                          'Save Task',
                          style: TextStyle(color: Colors.white),
                        );
                      },
                    )),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool?> showLeavePageDialoge() => showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: const Text('Dont want to creat task ?'),
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

class DeadLineWidget extends StatefulWidget {
  const DeadLineWidget({super.key, this.edit});

  final bool? edit;

  @override
  State<DeadLineWidget> createState() => _DeadLineWidgetState();
}

class _DeadLineWidgetState extends State<DeadLineWidget> {
  DateTime selectedDate = DateTime.now();

  TimeOfDay initialTime = TimeOfDay.now();

  bool taskStatus = false;

  String? selectedTime;
  TimeOfDay? formatedTime;
  String selectedDateFormatted =
      DateFormat('dd MMM yyyy').format(DateTime.now());

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;

        selectedDateFormatted = DateFormat('dd MMM yyyy').format(picked);
      });
    }
  }

  Future<void> selectTime(BuildContext context) async {
    await showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      helpText: 'Ending time',
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((value) {
      String times = value!.format(context);

      setState(() {
        selectedTime = times;
        formatedTime = value;
      });
      return null;
    }).onError((error, stackTrace) {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Deadline'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                selectDate(context);
              },
              child: Container(
                height: 40,
                padding: const EdgeInsets.only(
                  left: 5,
                  right: 5,
                ),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 20,
                    ),
                    Text(selectedDateFormatted),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                selectTime(context);
              },
              child: Container(
                height: 40,
                // width: 100,
                padding:
                    const EdgeInsets.only(left: 5, right: 5, top: 3, bottom: 3),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.timer),
                    Text(selectedTime == null ? 'Time' : selectedTime!),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        const Text('Task Status'),
        ChoiceChip(
          side: BorderSide.none,
          // selectedShadowColor: Colors.green.shade300,
          selectedColor: Colors.green,
          // disabledColor: Colors.red,
          elevation: 10,
          backgroundColor: taskStatus ? Colors.green : Colors.red,
          showCheckmark: false,
          label: taskStatus
              ? const Text(
                  'Completed',
                  style: TextStyle(color: Colors.white),
                )
              : const Text(
                  'Pending',
                  style: TextStyle(color: Colors.white),
                ),
          selected: taskStatus,
          onSelected: (value) {
            if (taskStatus) {
              setState(() {
                taskStatus = false;
              });
            } else {
              setState(() {
                taskStatus = true;
              });
            }
          },
        )
      ],
    );
  }
}

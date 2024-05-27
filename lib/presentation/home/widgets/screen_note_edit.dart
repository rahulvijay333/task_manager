import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_manager_rv/application/notes/note_edit/edit_bloc.dart';
import 'package:task_manager_rv/core/datetime/datime.dart';
import 'package:task_manager_rv/domain/task_model.dart';

class ScreenNoteEdit extends StatefulWidget {
  const ScreenNoteEdit({
    super.key,
    required this.taskModel, required this.userId,
  });

  final TaskModel taskModel;
  final String userId;

  @override
  State<ScreenNoteEdit> createState() => _ScreenNoteEditState();
}

class _ScreenNoteEditState extends State<ScreenNoteEdit> {
  final GlobalKey<_DeadLineWidgetEditState> deadlineKeyEdit =
      GlobalKey<_DeadLineWidgetEditState>();

  final titleController = TextEditingController();

  final descriptionController = TextEditingController();

  final timeTakenController = TextEditingController();

  editNote(TaskModel task) {
    BlocProvider.of<EditBloc>(context)
        .add(EditNoteEvent(task: task, userID: widget.userId));
  }

  @override
  void initState() {
    intializeValues();
    super.initState();
  }

  intializeValues() {
    titleController.text = widget.taskModel.title;
    descriptionController.text = widget.taskModel.description;
    timeTakenController.text = widget.taskModel.estimatedTime;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
        title: const Text(
          'Task',
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
                child: DeadLineWidgetEdit(
                  key: deadlineKeyEdit,
                  task: widget.taskModel,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: () {
                  if (titleController.text.isNotEmpty &&
                      descriptionController.text.isNotEmpty &&
                      timeTakenController.text.isNotEmpty &&
                      deadlineKeyEdit.currentState!.formatedTime != null) {
                    final datetime = DataTimeFunction().join(
                        deadlineKeyEdit.currentState!.selectedDate!,
                        deadlineKeyEdit.currentState!.formatedTime!);
                    final task = TaskModel(
                        id: widget.taskModel.id,
                        title: titleController.text,
                        description: descriptionController.text,
                        estimatedTime: timeTakenController.text,
                        dueDateTime: datetime,
                        taskStatus: deadlineKeyEdit.currentState!.taskStatus);
                    //-----------------------------save note function
                    editNote(task);
                    // addNote(task: task, context: context);
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8)),
                  width: size.width * 0.35,
                  height: 45,
                  child: Center(
                      child: BlocConsumer<EditBloc, EditState>(
                    listener: (context, state) {
                      if (state is EditNoteSuccess) {
                        Navigator.of(context).pop();
                      } else if (state is EditNoteFailed) {
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
                      if (state is EditnoteLoading) {
                        return const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 1,
                          ),
                        );
                      }

                      return const Text(
                        'Update Task',
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
    );
  }
}

class DeadLineWidgetEdit extends StatefulWidget {
  const DeadLineWidgetEdit({
    super.key,
    required this.task,
  });

  final TaskModel task;

  @override
  State<DeadLineWidgetEdit> createState() => _DeadLineWidgetEditState();
}

class _DeadLineWidgetEditState extends State<DeadLineWidgetEdit> {
  DateTime? selectedDate;

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
    }).onError((error, stackTrace) {
      log('error happend');
    });
  }

  @override
  void initState() {
    selectedDate = widget.task.dueDateTime;

    initialTime = TimeOfDay.now();

    taskStatus = widget.task.taskStatus;

    // selectedTime = TimeOfDay.fromDateTime(widget.task.dueDateTime);
    formatedTime = TimeOfDay.fromDateTime(widget.task.dueDateTime);
    selectedDateFormatted =
        DateFormat('dd MMM yyyy').format(widget.task.dueDateTime);
    super.initState();
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
                    selectedTime != null
                        ? Text(selectedTime!)
                        : Text(TimeOfDay.fromDateTime(widget.task.dueDateTime)
                            .format(context)),
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

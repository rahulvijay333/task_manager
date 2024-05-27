import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_manager_rv/domain/task_model.dart';

class FirebaseDbService {
  User? currentUser = FirebaseAuth.instance.currentUser;
  final fireInstance = FirebaseFirestore.instance;

  Stream<List<TaskModel>> getAllTasks(String userid) {
    return fireInstance
        .collection("users")
        .doc(userid)
        .collection("tasks")
        .snapshots()
        .map((event) =>
            event.docs.map((e) => TaskModel.fromJson(e.data())).toList());
  }

  Future<(bool, String?)> addNote(
      {required TaskModel task, required String userid}) async {
    log('add function called');

    try {
      await fireInstance
          .collection('users')
          .doc(userid)
          .collection('tasks')
          .doc(task.id)
          .set(task.toJson());

      return (true, '');
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        // Show an error message to the user

        return (false, 'Server Offline, Please try lator');
      } else {
        log(e.code);
        return (false, e.message);
      }
    }
  }

  Future<(bool, String?)> editNote(
      {required TaskModel task, required String userid}) async {
    try {
      await fireInstance
          .collection('users')
          .doc(userid)
          .collection('tasks')
          .doc(task.id)
          .update(task.toJson());

      return (true, '');
    } on FirebaseException catch (e) {
      return (false, e.message);
    }
  }

  Future<(bool, String?)> deleteNote(
      {required String id, required String userid}) async {
    try {
      await fireInstance
          .collection('users')
          .doc(userid)
          .collection('tasks')
          .doc(id)
          .delete();

      return (true, '');
    } on FirebaseException catch (e) {
      return (true, e.message);
    }
  }
}

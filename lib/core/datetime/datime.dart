import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DataTimeFunction {
  DateTime join(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  String getFormattedDateTime(DateTime dateTime) {
    //------------------------------------------------------------ Format the date
    String formattedDate = DateFormat('d MMMM, yyyy').format(dateTime);

    String formattedTime = DateFormat('h:mm a').format(dateTime);
    String formattedDateTime = '$formattedDate   Time: $formattedTime';

    return formattedDateTime;
  }

  int generateUniqueId() => DateTime.now().microsecondsSinceEpoch % (1 << 31);
}

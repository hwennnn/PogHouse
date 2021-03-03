import 'package:intl/intl.dart';

class Utils {
  Utils();

  String readTimestamp(int timestamp) {
    var format;

    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    final diffInDays = now.difference(date).inDays.abs();
    if (diffInDays < 1) {
      format = DateFormat('HH:mm');
    } else if (diffInDays < 7) {
      format = DateFormat('EEE, HH:mm');
    } else {
      format = DateFormat('d MMM, HH:mm');
    }

    return format.format(date);
  }
}

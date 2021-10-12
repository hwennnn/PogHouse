import 'package:intl/intl.dart';
import 'package:poghouse/app/model/people.dart';

import 'auth.dart';

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

  String getRoomID(Auth auth, String? peopleID) {
    final List<String?> ids = [auth.currentUser!.uid, peopleID];
    ids.sort();
    return ids.join('');
  }

  Map<String, People> constructMemberMap(Auth auth, People people) {
    Map<String, People> map = {};
    map[people.nickname!] = people;

    return map;
  }

  List<String> retrieveMembers(Auth auth, People people) {
    return [auth.currentUser!.uid, people.id!];
  }
}

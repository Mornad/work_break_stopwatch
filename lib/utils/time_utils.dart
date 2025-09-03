

Duration truncateToSecond(Duration d) =>
  Duration(seconds: d.inSeconds);

String getDate(DateTime dateTime){
  String year = dateTime.year.toString().padLeft(4, '0');
  String month = dateTime.month.toString().padLeft(2, '0');
  String day = dateTime.day.toString().padLeft(2, '0');

  return'$day-$month-$year';
}

Duration timeOfDay(DateTime dateTime) =>
    Duration(hours: dateTime.hour, minutes: dateTime.minute, seconds: dateTime.second);

String formatDuration(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }
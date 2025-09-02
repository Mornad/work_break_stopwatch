import 'dart:collection';

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



enum IntervalType {rest, work}

class TimeInterval {
  final IntervalType type;
  final Duration length;

  TimeInterval(this.type, this.length);

  factory TimeInterval.fromJson(Map<String, dynamic> json) {
    return TimeInterval(
      IntervalType.values[json['type']],          
      Duration(seconds: json['length']),          
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type.index,
        'length': length.inSeconds,
      };

}

class Session {
  final Duration startTime;
  final List<TimeInterval> _intervals = [];
  Duration _workTime = Duration.zero;
  Duration _restTime = Duration.zero;
  Duration _endTime = Duration.zero;

  Session({required this.startTime});

  UnmodifiableListView<TimeInterval> get intervals =>
      UnmodifiableListView(_intervals);

  Duration get workTime => _workTime;

  Duration get restTime => _restTime;

  Duration get endTime => _endTime;

  bool get ended => _endTime > Duration.zero;

  void addInterval(TimeInterval interval){
    _intervals.add(interval);

    interval.type == IntervalType.rest ? 
    _restTime += interval.length :
    _workTime += interval.length;
  }

  void endSession(){
    if (!ended && _intervals.isNotEmpty && _intervals.last.type == IntervalType.rest){
      _restTime -= _intervals.last.length;
      _intervals.removeLast();
    }
    _endTime += _restTime + _workTime;
  }

  factory Session.fromJson(Map<String, dynamic> json) {
    final session = Session(
      startTime: Duration(seconds: json['startTime']),
    );
    session._endTime = Duration(seconds: json['endTime']);
    for (final iJson in json['intervals']) {
      session.addInterval(TimeInterval.fromJson(iJson));
    }
    return session;
  }

  Map<String, dynamic> toJson() => {
        'startTime': startTime.inSeconds,
        'endTime': _endTime.inSeconds,
        'intervals': _intervals.map((interval) => interval.toJson()).toList(),
      };

}

class Day {
  final String id;
  final List<Session> _sessions = [];
  Duration _totalWorkTime = Duration.zero;
  Duration _totalRestTime = Duration.zero;

  
  Day({required this.id});

  Duration get totalWorkTime => _totalWorkTime;

  Duration get totalRestTime => _totalRestTime;

  UnmodifiableListView<Session> get sessions =>
      UnmodifiableListView(_sessions);

  bool addSession(Session session){
    if (session.ended){
      _sessions.add(session);
      _totalRestTime += session.restTime;
      _totalWorkTime += session.workTime;
    }

    return session.ended;
  }

  factory Day.fromJson(Map<String, dynamic> json) {
    final d = Day(id: json['id']);
    for (final sJson in json['sessions']) {
      final session = Session.fromJson(sJson);
      d.addSession(session);
    }
    return d;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'sessions': _sessions.map((session) => session.toJson()).toList(),
      };

}



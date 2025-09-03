import 'time_interval.dart';
import 'dart:collection';

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
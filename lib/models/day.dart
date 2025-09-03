import 'session.dart';
import 'dart:collection';

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
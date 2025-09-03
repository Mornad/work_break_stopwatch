
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
class Profile {
  final String email;
  final String name;
  final String state; // RESERVE, RETURN, LEAVE
  final String grade; // LOW, MIDDLE, HIGH
  final int dailyReservationTime; // 분 단위
  final int dailyAwayTime; // 분 단위
  final int depriveCount;

  Profile({
    required this.email,
    required this.name,
    required this.state,
    required this.grade,
    required this.dailyReservationTime,
    required this.dailyAwayTime,
    required this.depriveCount,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      email: json['email'] as String,
      name: json['name'] as String,
      state: json['state'] as String,
      grade: json['grade'] as String,
      dailyReservationTime: (json['dailyReservationTime'] ?? 0) as int,
      dailyAwayTime: (json['dailyAwayTime'] ?? 0) as int,
      depriveCount: (json['depriveCount'] ?? 0) as int,
    );
  }
}
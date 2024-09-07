class ReadSeatResponseDto {
  final int? userId; // null이 될 수 있으므로 int?로 변경
  final bool isUsed;
  final int useCount;
  final int? leaveId; // null이 될 수 있으므로 int?로 변경
  final int duration;
  final int leaveCount;
  final int? maxLeaveCount; // null이 될 수 있으므로 int?로 변경
  final int studyTime;

  ReadSeatResponseDto({
    required this.userId,
    required this.isUsed,
    required this.useCount,
    required this.leaveId,
    required this.duration,
    required this.leaveCount,
    required this.maxLeaveCount,
    required this.studyTime,
  });

  factory ReadSeatResponseDto.fromJson(Map<String, dynamic> json) {
    return ReadSeatResponseDto(
      userId: json['userId'] as int?, // null 허용
      isUsed: json['isUsed'] as bool? ?? false, // 기본값 false
      useCount: json['useCount'] as int? ?? 0, // 기본값 0
      leaveId: json['leaveId'] as int?, // null 허용
      duration: json['duration'] as int? ?? 0, // 기본값 0
      leaveCount: json['leaveCount'] as int? ?? 0, // 기본값 0
      maxLeaveCount: json['maxLeaveCount'] as int?, // null 허용
      studyTime: json['studyTime'] as int? ?? 0, // 기본값 0
    );
  }
}
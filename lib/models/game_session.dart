class GameSession {
  String id;
  List<Map<String, dynamic>> playersScores;
  String date;
  int tablet;
  int broken;
  GameSession({
    required this.id,
    required this.date,
    required this.tablet,
    required this.broken,
    required this.playersScores,
  });
}

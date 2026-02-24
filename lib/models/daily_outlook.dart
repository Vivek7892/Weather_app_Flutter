class DailyOutlook {
  final DateTime date;
  final double minTemp;
  final double maxTemp;
  final int rainProbability;
  final String condition;

  const DailyOutlook({
    required this.date,
    required this.minTemp,
    required this.maxTemp,
    required this.rainProbability,
    required this.condition,
  });
}

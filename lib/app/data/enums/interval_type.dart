enum IntervalType {
  ByTime,
  ByDistance,
}

///converts intervals to strings
String intervalAsStrings(IntervalType intervalType) {
  switch (intervalType) {
    case IntervalType.ByTime:
      return "Interval in Time";
    case IntervalType.ByDistance:
      return "Interval in Distance";
  }
}

///convert Intervals to Strings
IntervalType getIntervalType(String type) {
  switch (type) {
    case "Interval in Time":
      return IntervalType.ByTime;
    case "Interval in Distance":
      return IntervalType.ByDistance;
    default:
      return IntervalType.ByTime;
  }
}

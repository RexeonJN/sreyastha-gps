enum Feature { Marker, Route, Track }

List<String> getListOfFeatures() {
  return ["Marker", "Track", "Route"];
}

///as the region contains list of markers
String returnFeatureAsString(Feature feature) {
  switch (feature) {
    case Feature.Marker:
      return "Region";
    case Feature.Track:
      return "Track";
    case Feature.Route:
      return "Route";
  }
}

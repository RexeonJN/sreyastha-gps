import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:sreyastha_gps/app/core/constants/controllers.dart';
import 'package:sreyastha_gps/app/data/enums/interval_type.dart';
import 'package:sreyastha_gps/app/data/models/latlng_data.dart';

///track item is a combination of marker item and marker list
///Each of the points in the track item is a LatLngData
class TrackItem {
  ///there is no need of id or name as the filename can be used either as id or
  ///name

  ///Similar to the type of marker a route item can have the interval of
  /// tracking
  IntervalType typeOfInterval;

  TrackItem({this.typeOfInterval = IntervalType.ByTime});

  ///these points hold all the information related to a location
  Rx<List<LatlngData>> pointsInTrack = Rx<List<LatlngData>>([]);

  ///timer is used to set a time interval during tracking of data
  Timer? _timer;

  ///Tracking can only have two states which are either recording or stop
  ///false:not recording and true:recording
  final Rx<bool> recording = Rx<bool>(false);

  void setInterval(IntervalType value) {
    typeOfInterval = value;
  }

  ///it keeps on filling the list once the tracking has started
  void setValue() {
    ///timer is used to make consistent gap in time for time as interval
    if (typeOfInterval == IntervalType.ByTime) {
      if ((_timer != null && !_timer!.isActive) || _timer == null) {
        _timer = Timer(Duration(seconds: 4), () {
          if (_timer != null &&
              locationController.currentLocation.value != null) {
            pointsInTrack.value.add(
              locationController.currentLocation.value!,
            );
          }
        });
      }
    } else if (typeOfInterval == IntervalType.ByDistance) {
      ///distance from the last point is checked to maintain an interval in
      ///distance
      if (Geolocator.distanceBetween(
            pointsInTrack.value.last.location.latitude,
            pointsInTrack.value.last.location.longitude,
            locationController.currentLocation.value!.location.latitude,
            locationController.currentLocation.value!.location.longitude,
          ) >
          2) {
        pointsInTrack.value.add(
          locationController.currentLocation.value!,
        );
      }
    }
  }

  ///whenever it is called remember to send a starting point or else it
  ///will throw null check
  void startTracking(LatlngData startPoint) {
    ///turns the recording value to true and add the starting Latlng point to
    ///the list of polyline
    recording.value = true;
    pointsInTrack.value.add(startPoint);
  }

  void stopTracking() {
    ///turns off the recording and cancels the timer used for the time interval
    recording.value = false;
    if (_timer != null || (_timer != null && _timer!.isActive))
      _timer!.cancel();
  }

  void deleteTrackItem() {
    pointsInTrack.value = [];
  }

  ///these polypoints will be needed in order to plot the track in the map
  ///however it will not be used during storing the file
  Rx<List<LatLng>> get polylinePoints {
    return Rx(
        pointsInTrack.value.map((latlngdata) => latlngdata.location).toList());
  }

  ///these are the column names which will be defined in the csv
  List<String> get nameOfAttributes => [
        "Latitude",
        "Longitude",
        "Accuracy",
        "Altitude",
        "Date",
        "Time",
        "Speed",
        "SpeedAccuracy",
        "Interval type",
      ];

  ///each latlng data will be converted into a list which is then used by
  /// csv reader to generate a csv file
  List<String> valuesOfAttributes(LatlngData data) => [
        data.location.latitude.toStringAsFixed(6),
        data.location.longitude.toStringAsFixed(6),
        data.accuracy.toString(),
        data.altitude != null ? data.altitude.toString() : "0",
        "${data.timestamp.year}-${data.timestamp.month}-${data.timestamp.day}",
        "${data.timestamp.hour}-${data.timestamp.minute}-${data.timestamp.second}",
        data.speed != null ? data.speed!.toStringAsFixed(2) : "0",
        data.speedAccuracy != null
            ? data.speedAccuracy!.toStringAsFixed(2)
            : "0",
        intervalAsStrings(typeOfInterval),
      ];

  ///function to get the list of all LatLngData which can be saved
  ///later in csv
  List<List<String>> get trackItemValuesAsList {
    return pointsInTrack.value
        .map((oneRow) => valuesOfAttributes(oneRow))
        .toList();
  }

  ///A function to create track from the list
  void createTrackFromList(List<String> data) {
    final List<String> date = data[4].split('-');
    final List<String> time = data[5].split('-');
    pointsInTrack.value.add(
      LatlngData(
          location: LatLng(double.parse(data[0]), double.parse(data[1])),
          timestamp: DateTime(
              int.parse(date[0]),
              int.parse(date[1]),
              int.parse(date[2]),
              int.parse(time[0]),
              int.parse(time[1]),
              int.parse(time[2])),
          accuracy: double.tryParse(data[2]),
          altitude: data[3] == '0' ? 0 : double.parse(data[3]),
          speed: data[6] == '0' ? 0 : double.parse(data[6]),
          speedAccuracy: data[7] == '0' ? 0 : double.parse(data[7])),
    );
  }
}

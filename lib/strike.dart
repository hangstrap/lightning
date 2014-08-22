library lightningstrike;

class Strike {
  
  Strike();
  Strike.createWithCurrentTime(){
    timeMillis = new DateTime.now().millisecondsSinceEpoch;
  }
  
  
  int timeMillis;
  //DateTime get time => new DateTime.fromMillisecondsSinceEpoch(timeMillis, isUtc: true);
//  Duration get ago => new DateTime.now().toUtc().difference(time);
  
  String dateTime;
  double latitude;
  double longitude;
  double amplitude;
  String direction;
  Ellipse ellipse;
//  String toString() => "Strike< time=${time.toUtc()} ago=${ago.inHours} milisec = ${timeMillis} ${dateTime} ${direction} >";
}

class Ellipse {
  double major;
  double minor;
  int bearing;
}
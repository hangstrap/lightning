library lightningstrike;

class Strike 
{
  

  int timeMillis;
  
  String dateTime;
  double latitude;
  double longitude;
  double amplitude;
  String direction;
  Ellipse ellipse;

  
  Strike();
  Strike.createWithCurrentTime(){
    timeMillis = new DateTime.now().millisecondsSinceEpoch;
    direction = "?";
    longitude = 100.0;
    latitude = 100.0;
  }
  String toString(){
    return "${timeMillis} ${longitude} ${latitude}";
  }
}

class Ellipse {
  double major;
  double minor;
  int bearing;
}
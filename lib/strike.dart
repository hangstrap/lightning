library lightningstrike;

class Strike 
{
  int timeMillis;
  double latitude;
  double longitude;
  double amplitude;
  String direction;
  Ellipse ellipse;

  //used by the json constructor
  Strike();
  
  //Used for 'testing'
  Strike.createWithCurrentTime(){
    timeMillis = new DateTime.now().millisecondsSinceEpoch;
    direction = "?";
    longitude = 174.8;
    latitude = -41.3;
  }
  
  String toString()=>"${asDateTime}  E${longitude} S${latitude} ${amplitude}A ${direction}";
  DateTime get asDateTime => new DateTime.fromMillisecondsSinceEpoch( timeMillis, isUtc:true);
}

class Ellipse {
  double major;
  double minor;
  int bearing;
}
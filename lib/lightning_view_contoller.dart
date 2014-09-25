library lightning;

import 'package:angular/angular.dart';
import 'package:lightning/strike.dart';
import "dart:async";
import "dart:html";
import 'package:lightning/lightning_message.dart';
import 'package:lightning/lightning_web_socket.dart';

//import 'dart:html';
import 'package:google_maps/google_maps.dart';

@Controller(selector: '[current-strikes]', publishAs: 'lightingViewController')
class LightningViewController {

  List currentStrikes = [new Strike.createWithCurrentTime()];
  int statusCount = 0;


  GMap map;

  LightningViewController() {

    print("in constructor");

    visualRefresh = true;

    MapOptions mapOptions = new MapOptions()
        ..zoom = 4
        ..center = new LatLng(-34.397, 150.644)
        ..mapTypeId = MapTypeId.ROADMAP;

    map = new GMap(querySelector("#map_canvas"), mapOptions);

    new LightingWebSocket(getAuthDoc, receivedStrike, receivedStatus);
  }

  void addStrike() {
    receivedStrike(new Strike.createWithCurrentTime());
  }

  void receivedStrike(Strike strike) {
    print("received Strike ${strike}");

    if (strike.direction == 'CLOUD') return;


    currentStrikes.add(strike);
    if (currentStrikes.length > 10) {
      currentStrikes.removeAt(0);
    }
    LatLng latLong = new LatLng(strike.latitude, strike.longitude);
    double circleOpacity = 1.0;
    
    CircleOptions circleOptions = new CircleOptions()
    ..center = latLong
    ..strokeOpacity =circleOpacity
    ..map = map
    ..strokeColor = '#FF0000'
    ..fillOpacity =0
    ..radius = (strike.amplitude * 100000 / map.zoom)
    ..clickable = true;
    
    Circle circle = new Circle( circleOptions);

    circle.onClick.listen((e) {
      InfoWindow infoWindow = new InfoWindow(new InfoWindowOptions());
      infoWindow.content = "<div class='strikeInfo'><p>${strike.asDateTime} ${strike.direction} ${strike.amplitude}</p><div>";
      infoWindow.open(map, circle);

      new Future.delayed(new Duration(seconds: 10)).then((e) => infoWindow.close());
    });
    new Timer.periodic(new Duration(seconds: 3), (Timer timer){
      
      circleOpacity = circleOpacity - 0.1;
      print( 'circleOpacity = ${circleOpacity}');      
      if( circleOpacity <= 0){
        circle.map = null;
        timer.cancel();
      }else{      
        circleOptions.strokeOpacity = circleOpacity;
//        circleOptions.fillOpacity = circleOpacity;
        circle.options = circleOptions;

      }
    });


  }
  void receivedStatus(Status status) {
    print("received Status ${status.status}");
    statusCount++;
  }
  Future<String> getAuthDoc() {
    print("loading auth doc from server");
    return HttpRequest.getString("AuthDoc.txt");
  }
}

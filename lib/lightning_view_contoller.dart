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
        ..zoom = 8
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
    currentStrikes.add(strike);
    LatLng ll = new LatLng(strike.latitude, strike.longitude);
    map.panTo(ll);



    Marker marker = new Marker(new MarkerOptions()
        ..position = ll
        ..map = map
        ..title = "${strike.direction} ${strike.amplitude}");

    marker.onClick.listen((e) {
      InfoWindow infoWindow = new InfoWindow(new InfoWindowOptions());
      infoWindow.content = "<div class='strikeInfo'><p>${strike.asDateTime} ${strike.direction} ${strike.amplitude}</p><div>";
      infoWindow.open(map, marker);
      new Future.delayed( new Duration(seconds:10)).then( (e)=> infoWindow.close());
      
    });
    new Future.delayed( new Duration(minutes:10)).then( (e){
      marker.map = null;
      marker = null;
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

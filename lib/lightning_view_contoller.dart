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

  List currentStrikes = [];
  int statusCount = 0;
  bool showCloud = false;
  int fadeDelay = 10; //seconds

  GMap map;

  LightningViewController() {

    print("in constructor");

    visualRefresh = true;

    MapOptions mapOptions = new MapOptions()
        ..zoom = 4
        ..center = new LatLng(-34.397, 150.644)
        ..mapTypeId = MapTypeId.ROADMAP;

    map = new GMap(querySelector("#map_canvas"), mapOptions);
    
    //Unzipped: -java17 -java16.
    //Zipped: -java16 
    Map urls = {'localhost-java17': "ws://localhost:8088/websocket/v2", 
                'prod-oz-java16':"wss://lightning.metconnect.com.au/websocket/v2", 
                'test-oz-java17':"wss://test-lightning-au.metconnect.co.nz/websocket/v2", 
                'test-nz-java16':"wss://test-lightning.metconnect.co.nz/websocket/v2",
                'test-lpatz':"ws://ec2-54-253-177-143.ap-southeast-2.compute.amazonaws.com:8080/websocket/v2"};


    //open the web socket to Kattron
    new LightingWebSocket(urls['prod-oz-java16'], getAuthDoc, receivedKattronStrike, receivedStatus);
    
    //open the web socket to Gpats
    new LightingWebSocket(urls['test-lpatz'], getAuthDoc, receivedGpatsStrike, receivedStatus);
  }

  void addStrike() {
    
    receivedKattronStrike(new Strike.createWithCurrentTime());

  }

  void receivedKattronStrike(Strike strike) {
    strike.server = "Kattron";
    displayStrike(strike, "green", "green");
  }
  void receivedGpatsStrike(Strike strike) {
    strike.server = "Gpatz";
    displayStrike(strike, "red", "red");
  }
  void displayStrike(Strike strike, String groundColour, cloudColour) {
    
    print("${strike}");

    if ((strike.direction == 'CLOUD') && (!showCloud)) return;
    
    String server = strike.server;    
    if( inListOfStrikes( strike)){
      groundColour="black";
      cloudColour="black";
      server ="both";
    }

    addToListOfStrikes(strike);
    
    LatLng latLong = new LatLng(strike.latitude, strike.longitude);
    double circleOpacity = 1.0;

    CircleOptions circleOptions = new CircleOptions()
        ..center = latLong 
        ..strokeOpacity = circleOpacity
        ..map = map
        ..fillOpacity = 0
        ..clickable = true;

    if (strike.direction == "GROUND") {
      circleOptions.radius = (strike.amplitude.abs() * 100000 / map.zoom);
      circleOptions.strokeColor = groundColour;
    } else {
      circleOptions.radius = (100000 / map.zoom);
      circleOptions.strokeColor = cloudColour;
    }

    Circle circle = new Circle(circleOptions);

    circle.onClick.listen((e) {
      InfoWindow infoWindow = new InfoWindow(new InfoWindowOptions());
      infoWindow.content = "<div class='strikeInfo'><p>${server} ${strike.asDateTime}<br/>${strike.direction} ${strike.amplitude}A</p><div>";
      infoWindow.position = latLong;
      infoWindow.open(map);

      new Future.delayed(new Duration(seconds: 10)).then((e) => infoWindow.close());
    });

    new Timer.periodic(new Duration(seconds: fadeDelay ~/ 10), (Timer timer) {

      circleOpacity = circleOpacity - 0.1;

      if (circleOpacity <= 0) {
        circle.map = null;
        timer.cancel();
      } else {
        circleOptions.strokeOpacity = circleOpacity;
        circle.options = circleOptions;

      }
    });


  }

  bool inListOfStrikes( Strike strike){
    return currentStrikes.any( (Strike it) => ( it.latitude == strike.latitude) && ( it.longitude == strike.longitude));    
  }
  void addToListOfStrikes(Strike strike) {    
    currentStrikes.add(strike);
    if (currentStrikes.length > 10) {
      currentStrikes.removeAt(0);
    }
  }
  void receivedStatus(Status status) {
    statusCount++;
  }
  Future<String> getAuthDoc() {
    return HttpRequest.getString("AuthDoc2.txt");
  }
}

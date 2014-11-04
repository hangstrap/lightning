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
  int kattonStatusCount = 0;
  int gpatzStatusCount = 0;
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


    //Zipped: -java16 
    Map urls = {'localhost7': "ws://localhost:8088/websocket/v2", 
                'prod-oz':"wss://lightning.metconnect.com.au/websocket/v2", 
                'test-oz':"wss://test-lightning-au.metconnect.co.nz/websocket/v2",  
                'test-nz':"wss://test-lightning.metconnect.co.nz/websocket/v2",
                'test-lpatz':"ws://ec2-54-253-177-143.ap-southeast-2.compute.amazonaws.com:8080/websocket/v2",
                'test-lpatz-lb':"ws://dev-lightning-au-gpats-1383789414.ap-southeast-2.elb.amazonaws.com:8080/websocket/v2"};


    //open the web socket to Kattron
    new LightingWebSocket(urls['prod-oz'], getAuthDoc, receivedKattronStrike, receivedKattronStatus);

    //open the web socket to Gpats
    new LightingWebSocket(urls['test-lpatz-lb'], getAuthDoc, receivedGpatsStrike, receivedGpatzStatus);
  }

  void addStrike() {

    receivedKattronStrike(new Strike.createWithCurrentTime());

  }

  void receivedKattronStrike(Strike strike) {
    strike.server = "Kattron";
    processStrike(strike);
  }
  void receivedGpatsStrike(Strike strike) {
    strike.server = "Gpatz";
    processStrike(strike);
  }
  void processStrike(Strike strike) {


    if ((strike.direction == 'CLOUD') && (!showCloud)) return;

    print("${strike}");

    String colour = (strike.server == "Kattron") ? "green" : "red";


    if (inListOfStrikes(strike)) {
      colour = "white";
    }

    addToListOfStrikes(strike);

    displayStrike(strike, colour);
  }

  void displayStrike(Strike strike, String colour) {


    LatLng latLong = new LatLng(strike.latitude, strike.longitude);
    double circleOpacity = 1.0;

    CircleOptions circleOptions = new CircleOptions()
        ..center = latLong
        ..strokeOpacity = circleOpacity
        ..map = map
        ..fillOpacity = 0
        ..clickable = true;

    double amplitude = (strike.direction == "CLOUD") ? 1.0 : strike.amplitude.abs();
    circleOptions.radius = (amplitude * 10000 );
    circleOptions.strokeColor = colour;

    Circle circle = new Circle(circleOptions);

    circle.onClick.listen((e) {
      InfoWindow infoWindow = new InfoWindow(new InfoWindowOptions());
      infoWindow.content = "<div class='strikeInfo'><p>${strike.asDateTime}<br/>${strike.direction} ${strike.amplitude}A</p><div>";
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

  bool inListOfStrikes(Strike strike) {
    return currentStrikes.any((Strike it) => (it.latitude == strike.latitude) && (it.longitude == strike.longitude));
  }
  void addToListOfStrikes(Strike strike) {
    currentStrikes.add(strike);
    if (currentStrikes.length > 10) {
      currentStrikes.removeAt(0);
    }
  }
  void receivedKattronStatus(Status status) {
    kattonStatusCount++;
  }
  void receivedGpatzStatus(Status status) {
    gpatzStatusCount++;
  }
  Future<String> getAuthDoc() {
    return HttpRequest.getString("AuthDoc2.txt");
  }
}

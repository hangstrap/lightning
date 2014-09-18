library lightning;

import 'package:angular/angular.dart';
import 'package:lightning/strike.dart';
import "dart:async";
import "dart:html";
import 'package:lightning/lightning_message.dart';
import 'package:lightning/lightning_web_socket.dart';

@Controller(selector: '[current-strikes]', publishAs: 'lightingViewController')
class LightningViewController {

  List currentStrikes = [new Strike.createWithCurrentTime()];
  int statusCount=0;


  LightningViewController() {
    print("in constructor");

    new LightingWebSocket(getAuthDoc, receivedStrike, receivedStatus);
  }

  void addStrike() {
    Strike strike = new Strike.createWithCurrentTime();
    print( strike);
    currentStrikes.add( strike);
  }

  void receivedStrike(Strike strike) {
    print("received Strike ${strike}");
    currentStrikes.add(strike);
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

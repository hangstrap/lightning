

import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';
import 'package:lightning/lightning_view_contoller.dart';
import 'package:lightning/lightning_web_socket.dart';
import 'package:lightning/strike.dart';
import 'package:lightning/lightning_message.dart';

import "dart:async";
import "dart:html";

class MyAppModule extends Module {
  MyAppModule() {
    bind(LightningViewController);
//    type(LightningViewController);
  }
}

void main() {
  
  LightingWebSocket webSocket = new LightingWebSocket( getAuthDoc,  receivedStrike,receivedStatus );
  applicationFactory().addModule(new MyAppModule()).run();
  

}

void receivedStrike(Strike strike){
  print( "received Strike ${strike}");
}
void receivedStatus(Status status){
  print( "received Status ${status.status}");
}
Future<String> getAuthDoc(){
  print( "loading auth doc from server");
  return HttpRequest.getString( "AuthDoc.txt");
}


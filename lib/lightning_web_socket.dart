library lighting;


import "dart:html";
import "dart:async";
import 'package:lightning/lightning_message.dart';
import 'package:lightning/strike.dart';

//Define callbacks
typedef void receivedStrike(Strike strike);
typedef void receivedStatus(Status status);
typedef Future<String> getAuthDoc();

class LightingWebSocket {

  WebSocket webSocket;

  final getAuthDoc getAuthDocFunction;
  final receivedStrike receivedStikeFunction;
  final receivedStatus receivedStatusFunction;

  LightingWebSocket(this.getAuthDocFunction, this.receivedStikeFunction, this.receivedStatusFunction) {

    print("Starting web socket");
    webSocket = new WebSocket("wss://test-lightning-au.metconnect.co.nz/websocket/v2 ");

    webSocket.onOpen.forEach((_) {

      print("onOpen event has been fired - web socket is connected");
      webSocket.onMessage.forEach(onMessageReceived);
    });
    webSocket.onError.forEach((e) => print("web socket error ${e}"));
    webSocket.onClose.forEach((e) => print("web socket close ${e}"));


  }
  void onMessageReceived(MessageEvent e) {
    String data = e.data;
    print("receved message ${data}");

    LightingMessage s = decodeLightingMessageFromJson(data);
    switch (s.runtimeType) {
      case RequireAuthMessage:
        _sendAuthDocument();
        break;
      case AuthResponseMessage:
        AuthResponseMessage a = s;
        print("Auth responce ${a.authSuccess}");
        break;
      case StatusMessage:
        receivedStatusFunction(s.data);
        break;
      case StrikeMessage:
        receivedStikeFunction(s.data);
        break;
    }
  }
  void _sendAuthDocument() {

    getAuthDocFunction().then((String authDoc) {

      String json = encodeLightingMessageToJson(new AuthDocMessage.create(authDoc));
      print("About to send ${json}");
      webSocket.sendString(json);
    });
  }


}

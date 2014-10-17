library lighting;


import "dart:html";
import "dart:async";
import 'package:lightning/lightning_message.dart';
import 'package:lightning/strike.dart';
import 'package:logging/logging.dart';

//Define callbacks
typedef void receivedStrike(Strike strike);
typedef void receivedStatus(Status status);
typedef Future<String> getAuthDoc();

class LightingWebSocket {

  final Logger log = new Logger('LightingWebSocket');
  
  WebSocket webSocket;

  final getAuthDoc getAuthDocFunction;
  final receivedStrike receivedStikeFunction;
  final receivedStatus receivedStatusFunction;
  
  final String url;
  

  LightingWebSocket(this.url,  this.getAuthDocFunction, this.receivedStikeFunction, this.receivedStatusFunction) {

    log.info("Starting web socket");
    print( url);
    webSocket = new WebSocket(url);

    webSocket.onOpen.forEach((_) {

      log.info("onOpen event has been fired - web socket is connected");
      webSocket.onMessage.forEach(onMessageReceived);
    });
    webSocket.onError.forEach((e) => log.severe("web socket error ${e} ${url}"));
    webSocket.onClose.forEach((e) {
      log.severe("web socket close ${e}");
    });


  }
  void onMessageReceived(MessageEvent e) {
    String data = e.data;
    log.info("receved message ${data}");

    LightingMessage s = decodeLightingMessageFromJson(data);
    if (s.runtimeType == RequireAuthMessage) {
      _sendAuthDocument();
      
    } else if (s.runtimeType == AuthResponseMessage) {
      AuthResponseMessage a = s;      
      if( a.authSuccess){
        log.info("Auth responce ${a.authSuccess}");
      }else{
        log.severe("Auth responce failed ${a.data}");
      }
      
    } else if (s.runtimeType == StatusMessage) {
      receivedStatusFunction(s.data);
      
    } else if (s.runtimeType == StrikeMessage) {
      receivedStikeFunction(s.data);

    }
  }
  void _sendAuthDocument() {

    getAuthDocFunction().then((String authDoc) {

      String json = encodeLightingMessageToJson(new AuthDocMessage.create(authDoc));
      log.info("About to send ${json}");
      webSocket.sendString(json);
    });
  }


}

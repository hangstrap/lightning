library lighting;

import 'package:jsonx/jsonx.dart' as JSON;


import "dart:html";
import "dart:async";


class LightingWebSocket{
  
  WebSocket webSocket;
  
  LightingWebSocket(){
    print( "Starting web socket");
    webSocket = new WebSocket( "wss://test-lightning-au.metconnect.co.nz/websocket/v2 ");
    
    webSocket.onOpen.forEach((_) {

      print("onOpen event has been fired - web socket is connected");
      webSocket.onMessage.forEach(  onMessageReceived);
    });
    webSocket.onError.forEach( (e)=>print( "web socket error ${e}"));
    webSocket.onClose.forEach( (e)=>print( "web socket close ${e}"));
    
    
  }
  void onMessageReceived( MessageEvent e){
    print( "receved message ${e}");
    String data = e.data;
    print( "receved message ${data}");
    
    LightingJsonMessage s = JSON.decode( data, type: LightingJsonMessage);
    if( s.type == "401"){
      _sendAuthDocument();
    }
  }
  void _sendAuthDocument(){
    
  }
}

class LightingJsonMessage {
  int version;
  String type;
  Object data;
  LightingJsonMessage();
//  LightingJsonMessage(this.version, this.type, this.data);
}
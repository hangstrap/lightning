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
        _authReply(s);
        break;
      case StatusMessage:
        _statusMessage(s);
        break;
      case StrikeMessage:
        _lightingMessage(s);
        break;
    }
  }
  void _sendAuthDocument() {

    String key = 'eNo1UUluHDEM_EtfYxsitVD0OU_ILc6Bokh7gMyMMd3tLIb_HraBCIKgYpW4lN6XN7utp-tleUx3y77abXlc1td72deLbQ96PT_Ivtwtr7fr3HUL8gidbQvl20ntYfw8bX_tEpJ51f1sl0Pz_rSM636Z69Py-D3Aet23l7jfF3pId0_LL1u3gJDSJ3yx0_PLEfhPn-annIL--BGB7XS2SHE8KUQdK6ZjfURV-_16uv35KptFXUzQIOX0DeDgvxxHaNbT80W2_XZIspJ7stxQvEsnndZBRbLK7EhNgSs26gKFyZBrKW10oMq1sysYT2IvhqAD3XutqTElDxGVkXvyjFSgjqmFsoCV7rVZM6HB7CPnPC16kOkNwceUMTqDax8BSzPL06toZPBKXBKocclg00ikUq2CsZv4hEFmc0huyUWUmjNl5CTcWrVOglYke3LywiCY0SGxS68Ms5HXoVisoAFJIyZHhYSug0rFmo0ApcDMLUd_zVtCIqh9os6qVWdSzCy9cJmlacmNa5p0mKKpco8Zx8ittaRTkiqqVfapWTi3HpNF6zJnrWQS5g4jjpzQsPfg-wBUVTHtEM5ga2yaHWrQySCcZgohWPx59DQqp8P7QWoi8Rul5MFpCgxJeWobs3RMy8c_UHvX5g\$';

    getAuthDocFunction().then((String authDoc) {

      AuthDocMessage msg = new AuthDocMessage.create(key);

      String json = encodeLightingMessageToJson(msg);
      print("About to send ${json}");
      webSocket.sendString(json);


    });

  }

  void _authReply(AuthResponseMessage s) {
    print("Auth responce ${s.authSuccess}");
  }
  void _statusMessage(StatusMessage s) {
    receivedStatusFunction(s.data);
  }
  void _lightingMessage(StrikeMessage s) {
    receivedStikeFunction(s.data);
  }
}

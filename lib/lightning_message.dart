library lightning;

import 'package:jsonx/jsonx.dart' as JSON;

LightingMessage decodeLightingMessageFromJson(String json) {
  Map result = JSON.decode(json);
  switch (result[ 'type']) {
    case "401":
      return new RequireAuthMessage();
    case "auth":
      return JSON.decode( json, type: const JSON.TypeHelper<AuthResponseMessage>().type);
  }
  return null;
}

String encodeLightingMessageToJson( LightingMessage msg){
  return JSON.encode( msg);
}


class LightingMessage<T> {
  int version;
  String type ;
  T data;
}

class RequireAuthMessage extends LightingMessage {
  RequireAuthMessage();
}
class AuthDocMessage extends LightingMessage<String> {

  AuthDocMessage.create(String key){
    version =2;
    type ="auth";
    data = key;
  }
}
class AuthResponseMessage extends LightingMessage<Success> 
{
  bool get authSuccess => data.success;
}
class Success {
  bool success;
}
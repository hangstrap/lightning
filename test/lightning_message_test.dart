import 'package:unittest/unittest.dart';
import 'package:lightning/lightning_message.dart';

import 'package:jsonx/jsonx.dart' as JSON;

void main() {
  group("decode json", () {
    test("", () {
      String json = '{"version" : 2,"type" : "auth", "data" :  {"success" : true}}';
      AuthResponseMessage a = JSON.decode(json, type: const JSON.TypeHelper<AuthResponseMessage>().type);
      expect(a.data.success, equals(true));
    });

    test("should decode auth request", () {
      String json = '{"version" : 2,"type" : "401", "data" : "please send authorisation file."}';
      LightingMessage result = decodeLightingMessageFromJson(json);
      expect(result.runtimeType, equals(RequireAuthMessage));
    });

    test("should decode auth success", () {
      String json = '{"version" : 2,"type" : "auth", "data" :  {"success" : true}}';
      AuthResponseMessage result = decodeLightingMessageFromJson(json);
      expect(result.authSuccess, equals(true));
    });

    test("should decode status", () {
      String json = '{"version":2,"type":"status","data":{"status":"ok","since":1408205175415}}';
      StatusMessage result = decodeLightingMessageFromJson(json);
      expect(result.authSuccess, equals(true));
    });
  });

  group("encode json", () {
    test("should encode auth responce", () {

      AuthDocMessage msg = new AuthDocMessage.create("key");
      String result = encodeLightingMessageToJson(msg);
      expect(result, equals('{"version":2,"type":"auth","data":"key"}'));
    });
  });
}
String strike = '{"version":2,"type":"lightning","data":{"timeMillis":1408356097825,"dateTime":"2014-08-18T10:01:37.825Z","latitude":-34.6258,"longitude":159.8742,"amplitude":0.0,"direction":"CLOUD","ellipse":{"major":-1.0,"minor":-1.0,"bearing":-1}}}';

String status = '{"version":2,"type":"status","data":{"status":"ok","since":1408205175415}}';



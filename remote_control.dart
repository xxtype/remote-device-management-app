import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> sendRemoteCommand(String ip, Map<String, dynamic> command) async {
  try {
    String url = "http://$ip/control";
    Map<String, String> headers = {"Content-Type": "application/json"};
    String body = jsonEncode(command);

    var response = await http.post(Uri.parse(url), headers: headers, body: body);
    if (response.statusCode == 200) {
      print("Command sent successfully to $ip");
    } else {
      print("Failed to send command to $ip");
    }
  } catch (e) {
    print("Error controlling device at $ip: $e");
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiServices {
  ApiFetchService({required String follow_url}) async {
    print(follow_url);
    final url = follow_url;
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);

    print('\n\nAPI Response 2: $json\n\n');

    return json;
  }

  // ApiGetFollowNumber({required String getfollownumber_url}) async {
  //   print(getfollownumber_url);
  //   final url = getfollownumber_url;
  //   final uri = Uri.parse(url);
  //   final response = await http.get(uri);
  //   final body = response.body;
  //   final json = jsonDecode(body);
  // }
}

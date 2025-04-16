import 'dart:convert';
import 'package:http/http.dart' as http;

class GroupService {
 final baseUrl = Uri.parse('http://192.168.0.106:8082/api/groups');

  Future<int?> createGroup(String name, String currency, List<String> members) async {
    try {
      // Step 1: Create group
      final groupResponse = await http.post(
        baseUrl,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'currency': currency,
        }),
      );

      if (groupResponse.statusCode == 201) {
        final groupJson = json.decode(groupResponse.body);
        final groupId = groupJson['id'];

        // Step 2: Add members to group
        for (String memberName in members) {
          final memberUrl = Uri.parse('http://192.168.0.106:8082/api/groups/$groupId/members');

          await http.post(
            memberUrl,
            headers: {'Content-Type': 'application/json'},
            body: json.encode({'name': memberName}),
          );
        }

        return groupId;
      } else {
        print('❌ Failed to create group: ${groupResponse.statusCode}');
        print('Response: ${groupResponse.body}');
        return null;
      }
    } catch (e) {
      print('❌ Error creating group: $e');
      return null;
    }
  }
}

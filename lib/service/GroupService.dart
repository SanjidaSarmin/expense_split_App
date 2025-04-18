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

 // Method to fetch all groups
  Future<List<Map<String, dynamic>>> fetchGroups() async {
    final url = Uri.parse('http://192.168.0.106:8082/api/groups');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        return data.map<Map<String, dynamic>>((group) {
          return {
            'id': group['id'],
            'name': group['name'],
            'currency': group['currency'],
            'members': group['members']?.length ?? 0,
          };
        }).toList();
      } else {
        print('❌ Failed to fetch groups: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('❌ Error fetching groups: $e');
      return [];
    }
  }

Future<bool> deleteGroup(int groupId) async {
    final url = Uri.parse('http://192.168.0.106:8082/api/groups/$groupId');

    try {
      final response = await http.delete(url);
      if (response.statusCode == 200) {
        print('✅ Group deleted successfully.');
        return true;
      } else {
        print('❌ Failed to delete group: ${response.statusCode}');
        print('Response: ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ Error deleting group: $e');
      return false;
    }
  }
 

Future<List<Map<String, dynamic>>> getAllMembers() async {
  final url = Uri.parse('http://192.168.0.106:8082/api/members'); // adjust IP/port if needed

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map<Map<String, dynamic>>((member) {
        return {
          'id': member['id'],
          'name': member['name'],
        };
      }).toList();
    } else {
      print('❌ Failed to fetch members: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print('❌ Error fetching members: $e');
    return [];
  }
}




}

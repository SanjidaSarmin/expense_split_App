import 'dart:convert';
import 'package:http/http.dart' as http;

class MemberService {
  static const String baseUrl = 'http://localhost:8082/api'; // Your Spring Boot API URL

  // Get all members for a group
  Future<List<Member>> getMembersByGroupId(int groupId) async {
    final response = await http.get(Uri.parse('$baseUrl/members/group/$groupId'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Member.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load members');
    }
  }

  // Add member to a group (only name)
  Future<Member> addMemberToGroup(int groupId, String name) async {
    final response = await http.post(
      Uri.parse('$baseUrl/members/group/$groupId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(name), // Send the name only
    );

    if (response.statusCode == 201) {
      return Member.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add member');
    }
  }
}

class Member {
  final int id;
  final String name;

  Member({required this.id, required this.name});

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'],
      name: json['name'],
    );
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;

class ExpenseService {
  final String baseUrl = 'http://192.168.0.106:8082/api/expenses';

  // Create expense without using any model class.
  Future<bool> createExpense(Map<String, dynamic> request) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request),
    );

    return response.statusCode == 200;
  }

  // Fetch expenses by groupId without using any model class.
  Future<List<dynamic>> fetchExpensesByGroup(int groupId) async {
    final response = await http.get(Uri.parse('$baseUrl/group/$groupId'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);  // The response body is already a list.
    } else {
      throw Exception('Failed to load expenses');
    }
  }
}
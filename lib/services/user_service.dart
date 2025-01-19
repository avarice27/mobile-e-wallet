import 'dart:convert';

import 'package:bank_sha_rafi/models/user_model.dart';
import 'package:bank_sha_rafi/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:bank_sha_rafi/shared/api_path.dart';

class UserService {

  Future<List<UserModel>> getUsersByUsername(String username) async {
    try {
      final token = await AuthService().getToken();

      final res = await http.get(
        Uri.parse('$baseUrl/users/$username'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (res.statusCode == 200) {
        List<UserModel> users = List<UserModel>.from(
          jsonDecode(res.body).map(
            (user) => UserModel.fromJson(user),
          ),
        ).toList();

        return users;
      }

      return throw jsonDecode(res.body)['message'];
    } catch (e) {
      rethrow;
    }
  }

  Future<List<UserModel>> getRecentUsers() async {
    try {
      final token = await AuthService().getToken();

      final res = await http.get(
        Uri.parse('$baseUrl/transfer_histories'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (res.statusCode == 200) {
        List<UserModel> users = List<UserModel>.from(
          jsonDecode(res.body)['data'].map(
            (user) => UserModel.fromJson(user),
          ),
        ).toList();

        return users;
      }

      return throw jsonDecode(res.body)['message'];
    } catch (e) {
      rethrow;
    }
  }
}
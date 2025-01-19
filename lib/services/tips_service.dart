import 'dart:convert';

import 'package:bank_sha_rafi/models/tips_model.dart';
import 'package:bank_sha_rafi/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:bank_sha_rafi/shared/api_path.dart';

class TipsService {

  Future<List<TipsModel>> getTips() async {
    try {
      final token = await AuthService().getToken();

      final res = await http.get(
        Uri.parse('$baseUrl/tips'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (res.statusCode == 200) {
        List<TipsModel> tips = List<TipsModel>.from(
          jsonDecode(res.body)['data'].map(
            (tip) => TipsModel.fromJson(tip),
          ),
        ).toList();

        return tips;
      }

      return throw jsonDecode(res.body)['message'];
    } catch (e) {
      rethrow;
    }
  }
}
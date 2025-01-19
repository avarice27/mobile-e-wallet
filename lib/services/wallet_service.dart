import 'dart:convert';

import 'package:bank_sha_rafi/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:bank_sha_rafi/shared/api_path.dart';

class WalletService {

  Future<void> updatePin(String oldPin, String newPin) async {
    try {
      final String token = await AuthService().getToken();

      final res = await http.put(
        Uri.parse('$baseUrl/wallets'),
        body: {
          'previous_pin': oldPin,
          'new_pin': newPin,
        },
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (res.statusCode != 200) {
        throw jsonDecode(res.body)['message'];
      }
    } catch (e) {
      rethrow;
    }
  }
}
import 'dart:convert';

import 'package:bank_sha_rafi/models/sign_in_form_model.dart';
import 'package:bank_sha_rafi/models/sign_up_form_model.dart';
import 'package:bank_sha_rafi/models/user_edit_form_model.dart';
import 'package:bank_sha_rafi/models/user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:dartz/dartz.dart';
import 'package:bank_sha_rafi/shared/api_path.dart';
class AuthService {
  

  Future<bool> checkEmail(String email) async {
    try {
      final res = await http.post(
        Uri.parse(
          '$baseUrl/is-email-exist',
        ),
        body: {
          'email': email,
        },
      );

      if (res.statusCode == 200) {
        return jsonDecode(res.body)['is_email_exist'];
      } else {
        return jsonDecode(res.body)['errors'];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> register(SignUpFormModel data) async {
    try {
      final res = await http.post(
        Uri.parse(
          '$baseUrl/user/register',
        ),
        body: data.toJson(),
      );

       // Print response body for debugging
    print('Response body: ${res.body}');
      

      if (res.statusCode == 200 || res.statusCode == 201) {
        final user = UserModel.fromJson(jsonDecode(res.body));
        user.password = data.password;

        await storeCredentialToLocal(user);

        return user;
      } else {
        throw jsonDecode(res.body)['message'];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> login(SignInFormModel data) async {
    try {
      final res = await http.post(
        Uri.parse(
          '$baseUrl/user/login',
        ),
        body: data.toJson(),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        final user = UserModel.fromJson(jsonDecode(res.body));
        user.password = data.password;

        await storeCredentialToLocal(user);

        return user;
      } else {
        throw jsonDecode(res.body)['message'];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUser(UserEditFormModel data) async {
    try {
      final token = await getToken();

      final res = await http.put(
        Uri.parse(
          '$baseUrl/users',
        ),
        body: data.toJson(),
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

  Future<void> storeCredentialToLocal(UserModel user) async {
    try {
      const storage = FlutterSecureStorage();
      await storage.write(key: 'token', value: user.token);
      await storage.write(key: 'email', value: user.email);
      await storage.write(key: 'password', value: user.password);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getToken() async {
    String token = '';

    const storage = FlutterSecureStorage();
    String? value = await storage.read(key: 'token');

    if (value != null) {
      token = value;
    }

    return token;
  }

  Future<SignInFormModel> getCredentialFromLocal() async {
    try {
      const storage = FlutterSecureStorage();
      Map<String, String> values = await storage.readAll();

      if (values['token'] != null) {
        final SignInFormModel data = SignInFormModel(
          email: values['email'],
          password: values['password'],
        );

        return data;
      } else {
        throw 'unauthenticated';
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> clearLocalStorage() async {
    try {
      const storage = FlutterSecureStorage();
      await storage.deleteAll();
    } catch (e) {
      rethrow;
    }
  }

  // auth login
  // Future<Either<String, SignUpFormModel>> signUp(
  //     String email, String password, String name, String nim) async {
  //   final response =
  //       await http.post(Uri.parse('${baseUrl}/register'),
  //           // headers: {'User-Agent': Variables.userAgent},
  //           body: {'email': email, 'password': password, 'name': name, 'nim': nim});
  //   if (response.statusCode == 200) {
  //     return right(SignUpFormModel.fromJson(response.body));
  //   } else {
  //     return left(response.body);
  //   }
  // }
}
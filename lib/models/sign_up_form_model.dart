import 'dart:convert';

class SignUpFormModel {
  final String? name;
  final String? email;
  final String? password;
  final String? pin;
  final String? profilePicture;
  final String? ktp;
  final int roleId;
  final String? nim;

  // roles from API
  static const Map<int, String> roles = {
    1: 'admin',
    2: 'upnvj_student',
    3: 'general',
    4: 'high_school_student',
  };

  static dynamic getRoleDisplayName(dynamic roleName) {
    switch (roleName) {
      case 'admin':
        return 'Admin';
      case 'upnvj_student':
        return 'Mahasiswa UPNVJ';
      case 'general':
        return 'Umum';
      case 'high_school_student':
        return 'Siswa SMA';
      default:
        return roleName;
    }
  }

  SignUpFormModel({
    this.name,
    this.email,
    this.password,
    this.pin,
    this.profilePicture,
    this.ktp,
    required this.roleId,
    this.nim,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'pin': pin,
      'profile_picture': profilePicture,
      'ktp': ktp ?? "",
      'role_id': roleId.toString(),
      'nim': nim,
    };
  }

  factory SignUpFormModel.fromJson(Map<String, dynamic> json) {
    return SignUpFormModel(
      name: json['name'] as String,
      email: json['email'] as String?,
      password: json['password'] as String?,
      pin: json['pin'] as String?,
      profilePicture: json['profile_picture'] as String?,
      ktp: json['ktp'] as String?,
      roleId: int.parse(json['role_id'].toString()),
      nim: json['nim'] as String?,
    );
  }

  SignUpFormModel copyWith({
    // String? name,
    // String? email,
    // String? password,
    String? pin,
    String? profilePicture,
    String? ktp,
    int? roleId,
    String? nim,
  }) =>
      SignUpFormModel(
        // name: name ?? this.name,
        // email: email ?? this.email,
        // password: password ?? this.password,
        name: name,
        email: email,
        password: password,
        pin: pin ?? this.pin,
        profilePicture: profilePicture ?? this.profilePicture,
        ktp: ktp ?? this.ktp,
        roleId: roleId ?? this.roleId,
        nim: nim ?? this.nim,
      );
}

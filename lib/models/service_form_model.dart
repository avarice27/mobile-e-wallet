class ServiceModel {
  final String name;
  final int price;
  final int? roleId;
  final DateTime lastUpdated;
  String? pin;
  int? paymentMethodId;
  String? amount;

  ServiceModel({
    required this.name,
    required this.price,
    this.roleId,
    required this.lastUpdated,
    this.pin,
    this.paymentMethodId,
    this.amount,
  });
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

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    // Debug print to see the raw JSON
    print('Parsing service JSON: $json');
    print('Role ID from JSON: ${json['role_id']}');
    
    return ServiceModel(
      name: json['name'] as String,
      price: json['price'] as int,
      roleId: json['role_id'] != null ? json['role_id'] as int : null,
      lastUpdated: DateTime.parse(json['last_updated'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'role_id': roleId, 
      'last_updated': lastUpdated.toIso8601String(),
    };
  }

  ServiceModel copyWith({
  String? name,
  int? price,
  int? roleId,
  DateTime? lastUpdated,
  String? pin,
  int? paymentMethodId,
  String? amount,
}) {
  return ServiceModel(
    name: name ?? this.name,
    price: price ?? this.price,
    roleId: roleId ?? this.roleId,
    lastUpdated: lastUpdated ?? this.lastUpdated,
    pin: pin ?? this.pin,
    paymentMethodId: paymentMethodId ?? this.paymentMethodId,
    amount: amount ?? this.amount,
  );
}

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceModel &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          price == other.price &&
          roleId == other.roleId;

  @override
  int get hashCode => name.hashCode ^ price.hashCode ^ (roleId ?? 0).hashCode;

  @override
  String toString() {
    return 'ServiceModel(name: $name, price: $price, roleId: $roleId, lastUpdated: $lastUpdated)';
  }
}

class ServiceResponse {
  final bool error;
  final ServiceData data;

  ServiceResponse({
    required this.error,
    required this.data,
  });

  factory ServiceResponse.fromJson(Map<String, dynamic> json) {
    return ServiceResponse(
      error: json['error'] as bool? ?? false,
      data: ServiceData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class ServiceData {
  final String message;
  final List<ServiceModel> services;

  ServiceData({
    required this.message,
    required this.services,
  });

  factory ServiceData.fromJson(Map<String, dynamic> json) {
    print('Raw ServiceData JSON: $json'); // Debug print
    
    // Check if the data is in the '0' key or directly in a 'services' array
    var servicesJson = json['0'] ?? json['services'] ?? [];
    if (servicesJson is! List) {
      servicesJson = [];
    }

    return ServiceData(
      message: json['message'] as String? ?? '',
      services: servicesJson
          .map<ServiceModel>((e) {
            print('Processing service: $e'); // Debug print
            return ServiceModel.fromJson(e as Map<String, dynamic>);
          })
          .toList(),
    );
  }
}
import 'dart:convert';

class User {
  String name;
  String department;
  String apiToken;
  bool auth;
  User({
    required this.name,
    required this.department,
    required this.apiToken,
    required this.auth,
  });

  User.initial()
      : name = '',
        department = '',
        apiToken = '',
        auth = false;

  User copyWith({
    String? name,
    String? department,
    String? apiToken,
    bool? auth,
  }) {
    return User(
      name: name ?? this.name,
      department: department ?? this.department,
      apiToken: apiToken ?? this.apiToken,
      auth: auth ?? this.auth,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'department': department,
      'apiToken': apiToken,
      'auth': auth,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'],
      department: map['department'],
      apiToken: map['apiToken'],
      auth: false,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) {
    return User.fromMap(json.decode(source));
  }

  @override
  String toString() {
    return 'User(name: $name, department: $department, apiToken: $apiToken, auth: $auth)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.name == name &&
        other.department == department &&
        other.apiToken == apiToken &&
        other.auth == auth;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        department.hashCode ^
        apiToken.hashCode ^
        auth.hashCode;
  }
}

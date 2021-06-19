import 'dart:convert';

class User {
  String name;
  String depatment;
  User({
    required this.name,
    required this.depatment,
  });

  User copyWith({
    String? name,
    String? depatment,
  }) {
    return User(
      name: name ?? this.name,
      depatment: depatment ?? this.depatment,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'depatment': depatment,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'],
      depatment: map['depatment'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() => 'User(name: $name, depatment: $depatment)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User && other.name == name && other.depatment == depatment;
  }

  @override
  int get hashCode => name.hashCode ^ depatment.hashCode;
}

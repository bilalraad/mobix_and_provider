import 'dart:convert';

class DailyWork {
  final String agentName;
  final String phoneNumber;
  final String address;
  final String workType;
  DailyWork({
    required this.agentName,
    required this.phoneNumber,
    required this.address,
    required this.workType,
  });

  DailyWork copyWith({
    String? agentName,
    String? phoneNumber,
    String? address,
    String? workType,
  }) {
    return DailyWork(
      agentName: agentName ?? this.agentName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      workType: workType ?? this.workType,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'agentName': agentName,
      'phoneNumber': phoneNumber,
      'address': address,
      'workType': workType,
    };
  }

  factory DailyWork.fromMap(Map<String, dynamic> map) {
    return DailyWork(
      agentName: map['agentName'],
      phoneNumber: map['phoneNumber'],
      address: map['address'],
      workType: map['workType'],
    );
  }

  String toJson() => json.encode(toMap());

  factory DailyWork.fromJson(String source) =>
      DailyWork.fromMap(json.decode(source));

  @override
  String toString() {
    return 'DailyWork(agentName: $agentName, phoneNumber: $phoneNumber, address: $address, workType: $workType)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DailyWork &&
        other.agentName == agentName &&
        other.phoneNumber == phoneNumber &&
        other.address == address &&
        other.workType == workType;
  }

  @override
  int get hashCode {
    return agentName.hashCode ^
        phoneNumber.hashCode ^
        address.hashCode ^
        workType.hashCode;
  }
}

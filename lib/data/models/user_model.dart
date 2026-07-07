// FILE: lib/data/models/user_model.dart
// PURPOSE: User data model for Firestore

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String uid;
  final String name;
  final String phone;
  final String? email;
  final String role;
  final String? profileImage;
  final bool isBlocked;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime createdAt;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? updatedAt;
  final List<SavedAddress>? savedAddresses;

  UserModel({
    required this.uid,
    required this.name,
    required this.phone,
    this.email,
    required this.role,
    this.profileImage,
    this.isBlocked = false,
    required this.createdAt,
    this.updatedAt,
    this.savedAddresses,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel.fromJson({
      ...data,
      'uid': doc.id,
    });
  }

  static DateTime _timestampFromJson(Timestamp timestamp) => timestamp.toDate();
  static Timestamp _timestampToJson(DateTime date) => Timestamp.fromDate(date);
}

@JsonSerializable()
class SavedAddress {
  final String id;
  final String label;
  final String address;
  final double latitude;
  final double longitude;
  final bool isDefault;

  SavedAddress({
    required this.id,
    required this.label,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.isDefault = false,
  });

  factory SavedAddress.fromJson(Map<String, dynamic> json) => _$SavedAddressFromJson(json);
  Map<String, dynamic> toJson() => _$SavedAddressToJson(this);
}
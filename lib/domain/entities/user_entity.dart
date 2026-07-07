// FILE: lib/domain/entities/user_entity.dart
// PURPOSE: Business entity for User (immutable)

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_entity.freezed.dart';
part 'user_entity.g.dart';

@freezed
class UserEntity with _$UserEntity {
  const factory UserEntity({
    required String id,
    required String name,
    required String phone,
    String? email,
    required String role,
    String? profileImage,
    required bool isVerified,
    required bool isBlocked,
    required DateTime createdAt,
    DateTime? updatedAt,
    List<SavedAddressEntity>? savedAddresses,
  }) = _UserEntity;
  
  factory UserEntity.fromJson(Map<String, dynamic> json) => _$UserEntityFromJson(json);
}

@freezed
class SavedAddressEntity with _$SavedAddressEntity {
  const factory SavedAddressEntity({
    required String id,
    required String label,
    required String address,
    required double latitude,
    required double longitude,
    @Default(false) bool isDefault,
  }) = _SavedAddressEntity;
  
  factory SavedAddressEntity.fromJson(Map<String, dynamic> json) => _$SavedAddressEntityFromJson(json);
}
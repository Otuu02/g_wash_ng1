// FILE: lib/data/mappers/user_mapper.dart
// PURPOSE: Maps between UserModel and UserEntity

import '../../domain/entities/user_entity.dart';
import '../models/user_model.dart';

class UserMapper {
  static UserEntity toEntity(UserModel model) {
    return UserEntity(
      id: model.id!,
      name: model.name,
      phone: model.phone,
      email: model.email,
      role: model.role,
      profileImage: model.profileImage,
      isVerified: model.isVerified,
      isBlocked: model.isBlocked,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      savedAddresses: model.savedAddresses?.map((a) => SavedAddressEntity(
        id: a.id,
        label: a.label,
        address: a.address,
        latitude: a.latitude,
        longitude: a.longitude,
        isDefault: a.isDefault,
      )).toList(),
    );
  }
  
  static UserModel toModel(UserEntity entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      phone: entity.phone,
      email: entity.email,
      role: entity.role,
      profileImage: entity.profileImage,
      isVerified: entity.isVerified,
      isBlocked: entity.isBlocked,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      savedAddresses: entity.savedAddresses?.map((a) => SavedAddress(
        id: a.id,
        label: a.label,
        address: a.address,
        latitude: a.latitude,
        longitude: a.longitude,
        isDefault: a.isDefault,
      )).toList(),
    );
  }
}
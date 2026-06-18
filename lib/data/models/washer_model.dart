// FILE: lib/data/models/washer_model.dart
// PURPOSE: Washer-specific data model

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'washer_model.g.dart';

@JsonSerializable()
class WasherModel {
  final String? id;
  final String userId;
  final bool isOnline;
  final bool isApproved;
  final GeoPoint? currentLocation;
  final int workingRadiusKm;
  final double totalEarnings;
  final int totalJobs;
  final double rating;
  final int totalRatings;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? subscriptionValidUntil;
  final String? idImageUrl;
  final BankAccount? bankAccount;
  final String? vehicleType;
  final String? vehiclePlateNumber;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime lastUpdated;
  
  WasherModel({
    this.id,
    required this.userId,
    this.isOnline = false,
    this.isApproved = false,
    this.currentLocation,
    this.workingRadiusKm = 10,
    this.totalEarnings = 0,
    this.totalJobs = 0,
    this.rating = 0,
    this.totalRatings = 0,
    this.subscriptionValidUntil,
    this.idImageUrl,
    this.bankAccount,
    this.vehicleType,
    this.vehiclePlateNumber,
    required this.lastUpdated,
  });
  
  factory WasherModel.fromJson(Map<String, dynamic> json) => _$WasherModelFromJson(json);
  Map<String, dynamic> toJson() => _$WasherModelToJson(this);
  
  factory WasherModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return WasherModel.fromJson({
      ...data,
      'id': doc.id,
    });
  }
  
  static DateTime _timestampFromJson(Timestamp timestamp) => timestamp.toDate();
  static Timestamp _timestampToJson(DateTime date) => Timestamp.fromDate(date);
  
  bool get isSubscriptionActive {
    if (subscriptionValidUntil == null) return false;
    return subscriptionValidUntil!.isAfter(DateTime.now());
  }
}

@JsonSerializable()
class BankAccount {
  final String bankName;
  final String accountNumber;
  final String accountName;
  
  BankAccount({
    required this.bankName,
    required this.accountNumber,
    required this.accountName,
  });
  
  factory BankAccount.fromJson(Map<String, dynamic> json) => _$BankAccountFromJson(json);
  Map<String, dynamic> toJson() => _$BankAccountToJson(this);
}
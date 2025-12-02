import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  final String id;
  final String? fullName;
  final String? phoneNumber;
  final String? preferredContactMethod;
  final String role;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Profile({
    required this.id,
    this.fullName,
    this.phoneNumber,
    this.preferredContactMethod,
    this.role = 'client',
    this.createdAt,
    this.updatedAt,
  });

  bool get isAdmin => role == 'super_admin';
  bool get isClient => role == 'client';

  @override
  List<Object?> get props => [
        id,
        fullName,
        phoneNumber,
        preferredContactMethod,
        role,
        createdAt,
        updatedAt,
      ];
}


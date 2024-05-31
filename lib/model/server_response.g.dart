// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServerResponse<T> _$ServerResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    ServerResponse<T>(
      status: (json['status'] as num).toInt(),
      description: json['description'] as String,
      data: json['data'] as String?,
    );

Map<String, dynamic> _$ServerResponseToJson<T>(
  ServerResponse<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'status': instance.status,
      'description': instance.description,
      'data': instance.data,
    };

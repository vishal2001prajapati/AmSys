import 'package:json_annotation/json_annotation.dart';

part 'server_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ServerResponse<T> {
  const ServerResponse({
    required this.status,
    required this.description,
    required this.data,
  });

  factory ServerResponse.fromJson(Map<String, dynamic> json, T Function(Object?) fromJsonT) => _$ServerResponseFromJson(json, fromJsonT);

  final int status;
  final String description;
  @JsonKey(name: "data")
  final String? data;

  Map<String, dynamic> toJson(Object? Function(T) toJsonT) => _$ServerResponseToJson(this, toJsonT);

  @override
  String toString() => 'ServerResponse{ status: $status message: $description data: $data}';

  bool get is200 => status >= 200 && status < 300;

  bool get is400 => status >= 200 && status < 300;

  bool get is404 => status == 404;
}



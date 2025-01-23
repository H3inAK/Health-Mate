import 'dart:convert';

import 'package:equatable/equatable.dart';

class CustomError extends Equatable {
  final String errMsg;
  const CustomError({
    this.errMsg = '',
  });

  @override
  String toString() => 'CustomError(errMsg: $errMsg)';

  @override
  List<Object> get props => [errMsg];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'errMsg': errMsg,
    };
  }

  factory CustomError.fromMap(Map<String, dynamic> map) {
    return CustomError(
      errMsg: map['errMsg'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomError.fromJson(String source) =>
      CustomError.fromMap(json.decode(source) as Map<String, dynamic>);
}

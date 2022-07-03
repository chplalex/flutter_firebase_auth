// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_with_credential_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginWithCredentialRequest _$LoginWithCredentialRequestFromJson(
        Map<String, dynamic> json) =>
    LoginWithCredentialRequest(
      providerId: json['providerId'] as String?,
      signInMethod: json['signInMethod'] as String?,
      accessToken: json['accessToken'] as String?,
      idToken: json['idToken'] as String?,
      secret: json['secret'] as String?,
      rawNonce: json['rawNonce'] as String?,
    );

Map<String, dynamic> _$LoginWithCredentialRequestToJson(
        LoginWithCredentialRequest instance) =>
    <String, dynamic>{
      'providerId': instance.providerId,
      'signInMethod': instance.signInMethod,
      'accessToken': instance.accessToken,
      'idToken': instance.idToken,
      'secret': instance.secret,
      'rawNonce': instance.rawNonce,
    };

import 'package:firebase_auth/firebase_auth.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_with_credential_request.g.dart';

@JsonSerializable()
class LoginWithCredentialRequest {
  String? providerId;
  String? signInMethod;
  String? accessToken;
  String? idToken;
  String? secret;
  String? rawNonce;

  LoginWithCredentialRequest({
    this.providerId,
    this.signInMethod,
    this.accessToken,
    this.idToken,
    this.secret,
    this.rawNonce,
  });

  factory LoginWithCredentialRequest.fromJson(final Map<String, dynamic> json) {
    return _$LoginWithCredentialRequestFromJson(json);
  }

  Map<String, dynamic> toJson() => _$LoginWithCredentialRequestToJson(this);

  static LoginWithCredentialRequest fromCredential(OAuthCredential credential) {
    final credentialMap = credential.asMap();
    return LoginWithCredentialRequest(
      providerId: credentialMap['providerId'],
      signInMethod: credentialMap['signInMethod'],
      accessToken: credentialMap['accessToken'],
      idToken: credentialMap['idToken'],
      secret: credentialMap['secret'],
      rawNonce: credentialMap['rawNonce'],
    );
  }

  static LoginWithCredentialRequest fromUserCredential(UserCredential credential, String accessToken) {
    return LoginWithCredentialRequest(
      providerId: credential.credential?.providerId,
      signInMethod: credential.credential?.signInMethod,
      accessToken: accessToken,
      idToken: null,
      secret: null,
      rawNonce: null,
    );
  }
}
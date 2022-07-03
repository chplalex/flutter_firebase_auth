import "dart:async";
import 'package:chopper/chopper.dart';

import 'login_with_credential_request.dart';

// This is necessary for the generator to work.
part "api_service.chopper.dart";

const _SERVER_URL = 'https://magen-dev-server.azurewebsites.net';
const _LOCAL_URL = 'http://192.168.10.69:5000';

@ChopperApi()
abstract class ApiService extends ChopperService {
  static ApiService create() {
    final client = ChopperClient(
      baseUrl: _LOCAL_URL,
      services: [_$ApiService()],
      converter: const JsonConverter(),
      interceptors: [HttpLoggingInterceptor()],
    );
    return _$ApiService(client);
  }

  @Post(path: "/api/v2/auth/loginCredential")
  Future<Response> loginWithCredential(@Body() LoginWithCredentialRequest request);
}

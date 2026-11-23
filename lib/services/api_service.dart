import 'http_app_api.dart';

class ApiService extends HttpAppApi {
  ApiService({
    super.baseUri,
    super.client,
    super.onUnauthorized,
  });
}

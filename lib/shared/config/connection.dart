const String API_URL = "https://mgm1.dishtele.com/api/v1/";

Uri getUri(String path) {
  String _path = Uri.parse(API_URL).path;
  if (!_path.endsWith('/')) {
    _path += '/';
  }
  return new Uri(
    scheme: Uri.parse(API_URL).scheme,
    host: Uri.parse(API_URL).host,
    port: Uri.parse(API_URL).port,
    path: _path + path,
  );
}

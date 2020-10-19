class HttpExcept implements Exception {
  final String message;
  HttpExcept(this.message);

  @override
  String toString() {
    return message;
  }
}

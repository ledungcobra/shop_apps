
class HttpException implements Exception{
  final String errorMessage;
  HttpException(this.errorMessage);
  @override
  String toString() {
    // TODO: implement toString
    return errorMessage;
  }


}
enum Status { SUCESS, FAILURE }

class AppResult<T> {
  Status status;
  String message;
  int statusCode;
  T data;

  AppResult.success([this.data]) : status = Status.SUCESS;
  AppResult.failure([this.message, this.statusCode]) : status = Status.FAILURE;
}

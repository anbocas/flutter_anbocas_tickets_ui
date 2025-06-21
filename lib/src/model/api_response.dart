class ApiResponse<T> {
  ApiResponse({this.data, this.error});
  T? data;
  String? error;
}

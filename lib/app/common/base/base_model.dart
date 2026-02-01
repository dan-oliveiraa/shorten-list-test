class BaseViewModel {
  String state;
  bool isLoading;
  BaseViewModel({
    required this.state,
    this.isLoading = false,
  });
}

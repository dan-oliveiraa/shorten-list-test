sealed class Result<S, F> {
  const Result();
}

class Success<S, F> extends Result<S, F> {
  final S data;
  const Success(this.data);
}

class Failure<S, F> extends Result<S, F> {
  final F error;
  const Failure(this.error);
}

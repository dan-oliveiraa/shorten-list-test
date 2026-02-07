import 'package:shorten_list_test/app/feature/shortened_url/domain/entities/shortened_link_entity.dart';

sealed class HomeState {
  const HomeState();
}

final class HomeLoading extends HomeState {
  String? message;
  HomeLoading({this.message});
}

final class HomeLoaded extends HomeState {
  final List<ShortenedLinkEntity> recentUrls;
  HomeLoaded({this.recentUrls = const []});
}

final class HomeError extends HomeState {
  const HomeError(this.message);
  final String message;
}

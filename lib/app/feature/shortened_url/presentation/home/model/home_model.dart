import 'package:shorten_list_test/app/feature/shortened_url/domain/entities/shortened_link_entity.dart';
import 'package:shorten_list_test/app/feature/shortened_url/presentation/home/model/home_state.dart';

class HomeViewModel {
  List<ShortenedLinkEntity> shortenedLinks;
  HomeState state;
  HomeViewModel({
    required this.state,
    this.shortenedLinks = const [],
  });
}

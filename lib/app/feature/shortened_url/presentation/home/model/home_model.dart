import 'package:shorten_list_test/app/common/base/base_model.dart';
import 'package:shorten_list_test/app/feature/shortened_url/domain/entities/shortened_link_entity.dart';

class HomeViewModel extends BaseViewModel {
  List<ShortenedLinkEntity> shortenedLinks;
  HomeViewModel({
    required super.state,
    super.isLoading = false,
    this.shortenedLinks = const [],
  });
}

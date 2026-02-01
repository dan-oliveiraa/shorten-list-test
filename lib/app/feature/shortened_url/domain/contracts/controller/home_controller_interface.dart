import 'package:shorten_list_test/app/common/base/base_controller.dart';
import 'package:shorten_list_test/app/feature/shortened_url/domain/value_objects/shorten_url_input.dart';

import '../../entities/shortened_link_entity.dart';

abstract class IHomeController extends BaseController {
  Future<void> send();
  List<ShortenedLinkEntity> get recentUrls;
  ShortenUrlInput get input;
}

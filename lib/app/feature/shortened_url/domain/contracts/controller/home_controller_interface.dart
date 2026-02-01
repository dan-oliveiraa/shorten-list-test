import 'package:shorten_list_test/app/common/base/base_controller.dart';
import 'package:shorten_list_test/app/feature/shortened_url/application/dto/shorten_url_input.dart';

import '../../entities/shortened_link_entity.dart';

abstract class IHomeController extends BaseController {
  Future<void> send();
  List<ShortenedLinkEntity> get recentUrls;
  ShortenUrlInputDTO get input;
}

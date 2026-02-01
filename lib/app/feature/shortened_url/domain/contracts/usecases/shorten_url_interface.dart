import 'package:shorten_list_test/app/core/models/result.dart';
import 'package:shorten_list_test/app/feature/shortened_url/application/dto/shorten_url_input.dart';
import 'package:shorten_list_test/app/feature/shortened_url/domain/entities/shortened_link_entity.dart';

abstract class IShortenUrlUseCase {
  Future<Result<ShortenedLinkEntity, String>> call(ShortenUrlInputDTO input);
}

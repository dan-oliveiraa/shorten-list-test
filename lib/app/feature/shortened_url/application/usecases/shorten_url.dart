import 'package:shorten_list_test/app/core/models/result.dart';
import 'package:shorten_list_test/app/feature/shortened_url/application/dto/shorten_url_input.dart';
import 'package:shorten_list_test/app/feature/shortened_url/domain/contracts/ports/repositories/url_repository_port.dart';
import 'package:shorten_list_test/app/feature/shortened_url/domain/contracts/usecases/shorten_url_interface.dart';
import 'package:shorten_list_test/app/feature/shortened_url/domain/entities/shortened_link_entity.dart';

class ShortenUrlUseCase implements IShortenUrlUseCase {
  final UrlRepositoryPort _port;

  ShortenUrlUseCase(this._port);

  @override
  Future<Result<ShortenedLinkEntity, String>> call(ShortenUrlInputDTO input) async {
    final resp = await _port.shortenUrl(input);

    if (resp.isEmpty) {
      return Failure('Valores inválidos. Não adicionar na lista');
    }

    return Success(resp);
  }
}

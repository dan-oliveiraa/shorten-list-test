import 'package:rxdart/rxdart.dart';
import 'package:shorten_list_test/app/core/contracts/guards/safe_executor_interface.dart';
import 'package:shorten_list_test/app/core/models/result.dart';
import 'package:shorten_list_test/app/core/utils/stream_emitter.dart';
import 'package:shorten_list_test/app/feature/shortened_url/domain/contracts/controller/home_controller_interface.dart';
import 'package:shorten_list_test/app/feature/shortened_url/domain/contracts/usecases/shorten_url_interface.dart';
import 'package:shorten_list_test/app/feature/shortened_url/domain/value_objects/shorten_url_input.dart';
import 'package:shorten_list_test/app/feature/shortened_url/presentation/home/model/home_model.dart';
import 'package:shorten_list_test/app/feature/shortened_url/presentation/home/model/home_state.dart';

import '../../domain/entities/shortened_link_entity.dart';

class HomeController extends IHomeController {
  final IShortenUrlUseCase _shortenUrlUseCase;
  final ISafeExecutor _safeExecutor;

  HomeController(
    this._shortenUrlUseCase,
    this._safeExecutor,
  );

  final BehaviorSubject<HomeViewModel> _streamController = BehaviorSubject<HomeViewModel>();
  final ShortenUrlInput _input = ShortenUrlInput.empty();
  final List<ShortenedLinkEntity> _recentUrls = [];

  @override
  ShortenUrlInput get input => _input;
  @override
  StreamEmitter<HomeViewModel> get emitter => StreamEmitter(_streamController);
  @override
  Stream<HomeViewModel> get onState => _streamController.stream;
  @override
  List<ShortenedLinkEntity> get recentUrls => _recentUrls;

  @override
  Future<void> send() async {
    await _safeExecutor.guard(
      () async {
        emitter.emit(
          HomeViewModel(
            state: HomeLoading(),
          ),
        );

        final valueObject = _input;

        final result = await _shortenUrlUseCase.call(valueObject);

        return switch (result) {
          Success(:final data) => _feedViewModel(data),
          Failure(:final error) => emitter.emitError(error),
        };
      },
      contextErrorMessage: 'Erro ao enviar URL',
      onError: (globalError) => emitter.emitError(globalError),
    );
  }

  void _feedViewModel(ShortenedLinkEntity data) {
    _recentUrls.add(data);
    emitter.emit(
      HomeViewModel(
        state: HomeLoaded(),
        shortenedLinks: _recentUrls,
      ),
    );
  }
}

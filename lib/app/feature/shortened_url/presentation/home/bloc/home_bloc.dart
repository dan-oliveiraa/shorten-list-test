import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shorten_list_test/app/core/contracts/guards/safe_executor_interface.dart';
import 'package:shorten_list_test/app/core/models/result.dart';
import 'package:shorten_list_test/app/feature/shortened_url/domain/contracts/usecases/shorten_url_interface.dart';
import 'package:shorten_list_test/app/feature/shortened_url/domain/entities/shortened_link_entity.dart';
import 'package:shorten_list_test/app/feature/shortened_url/domain/value_objects/shorten_url_input.dart';
import 'package:shorten_list_test/app/feature/shortened_url/presentation/home/bloc/home_event.dart';
import 'package:shorten_list_test/app/feature/shortened_url/presentation/home/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final IShortenUrlUseCase _shortenUrlUseCase;
  final ISafeExecutor _safeExecutor;
  ShortenUrlInput get input => _input;

  HomeBloc(
    this._shortenUrlUseCase,
    this._safeExecutor,
  ) : super(HomeLoaded()) {
    on<HomeSendEvent>(send);
    on<HomeRefreshEvent>(refresh);
  }

  final ShortenUrlInput _input = ShortenUrlInput.empty();

  final List<ShortenedLinkEntity> recentUrls = [];

  Future<void> send(HomeSendEvent event, Emitter<HomeState> emit) async {
    await _safeExecutor.guard(
      () async {
        emit(HomeLoading());

        final valueObject = _input;
        final result = await _shortenUrlUseCase.call(valueObject);

        return switch (result) {
          Success(:final data) => _success(data, emit),
          Failure(:final error) => emit(HomeError(error)),
        };
      },
      contextErrorMessage: 'Erro ao enviar URL',
      onError: (globalError) => emit(HomeError(globalError.message)),
    );
  }

  void _success(ShortenedLinkEntity data, Emitter<HomeState> emit) {
    recentUrls.add(data);
    emit(HomeLoaded(recentUrls: recentUrls));
  }

  void refresh(HomeRefreshEvent event, Emitter<HomeState> emit) =>
      emit(HomeLoaded(recentUrls: recentUrls));
}

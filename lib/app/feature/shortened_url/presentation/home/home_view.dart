import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shorten_list_test/app/common/widgets/error/error_view.dart';
import 'package:shorten_list_test/app/feature/shortened_url/presentation/home/bloc/home_bloc.dart';
import 'package:shorten_list_test/app/feature/shortened_url/presentation/home/bloc/home_event.dart';
import 'package:shorten_list_test/app/feature/shortened_url/presentation/home/bloc/home_state.dart';
import 'package:shorten_list_test/app/feature/shortened_url/presentation/home/widgets/template/home_url_template.dart';
import 'package:shorten_list_test/app/feature/shortened_url/presentation/home/widgets/template/skeleton_home_url_template.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _urlController = TextEditingController();

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              return switch (state) {
                HomeLoading() => SkeletonHomeUrlTemplate(urlController: _urlController),
                HomeError(:final message) => ErrorView(
                    onPressed: () => context.read<HomeBloc>().add(HomeRefreshEvent()),
                    message: message,
                  ),
                HomeLoaded(:final recentUrls) => HomeUrlTemplate(
                    urlController: _urlController,
                    shortenUrl: () => context.read<HomeBloc>().add(HomeSendEvent()),
                    recentUrls: recentUrls,
                    input: context.read<HomeBloc>().input,
                  ),
              };
            },
          ),
        ),
      ),
    );
  }
}

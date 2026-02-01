import 'package:flutter/material.dart';
import 'package:shorten_list_test/app/common/states/app_states.dart';
import 'package:shorten_list_test/app/feature/shortened_url/domain/contracts/controller/home_controller_interface.dart';
import 'package:shorten_list_test/app/feature/shortened_url/presentation/home/model/home_model.dart';
import 'package:shorten_list_test/app/feature/shortened_url/presentation/home/widgets/template/home_url_template.dart';
import 'package:shorten_list_test/app/feature/shortened_url/presentation/home/widgets/template/skeleton_home_url_template.dart';

class HomeView extends StatefulWidget {
  final IHomeController controller;
  const HomeView(this.controller, {super.key});

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
        child: StreamBuilder<HomeViewModel>(
          stream: widget.controller.onState.cast<HomeViewModel>(),
          initialData: HomeViewModel(state: AppStates.isLoaded),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Erro: ${snapshot.error}'),
              );
            }

            if (snapshot.hasData && snapshot.data!.isLoading) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: SkeletonHomeUrlTemplate(
                  urlController: _urlController,
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: HomeUrlTemplate(
                urlController: _urlController,
                shortenUrl: widget.controller.send,
                recentUrls: widget.controller.recentUrls,
              ),
            );
          },
        ),
      ),
    );
  }
}

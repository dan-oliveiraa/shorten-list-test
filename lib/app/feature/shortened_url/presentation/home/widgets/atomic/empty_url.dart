import 'package:flutter/material.dart';
import 'package:shorten_list_test/app/common/widgets/empty_data.dart';

class EmptyUrl extends StatelessWidget {
  const EmptyUrl({super.key});

  @override
  Widget build(BuildContext context) {
    return EmptyData(message: 'No URLs yet');
  }
}

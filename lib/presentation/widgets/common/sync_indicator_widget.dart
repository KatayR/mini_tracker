import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_dimens.dart';

class SyncIndicatorWidget extends StatelessWidget {
  const SyncIndicatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.p16, vertical: AppDimens.p4),
          child: Text(AppStrings.syncing, style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center),
        ),
        const LinearProgressIndicator(),
      ],
    );
  }
}

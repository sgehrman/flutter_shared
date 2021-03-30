import 'package:flutter/material.dart';
import 'package:flutter_shared/src/utils/utils.dart';
import 'package:flutter_shared/src/widgets/ttext.dart';

class PrimaryTitle extends StatelessWidget {
  const PrimaryTitle({
    @required this.title,
    this.action,
  });

  final String title;
  final Widget action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          Expanded(
            child: TText(
              title,
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          action ?? NothingWidget(),
        ],
      ),
    );
  }
}

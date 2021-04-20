import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class Spin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SpinKitCircle(
      itemBuilder: (BuildContext context, int index) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: index.isEven
                ? Colors.purpleAccent
                : Colors.purple,
          ),
        );
      },
    );
  }
}


class Spinn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlareActor(
      "assets/money.flr",alignment: Alignment.center,
      fit: BoxFit.cover,

    );
  }
}


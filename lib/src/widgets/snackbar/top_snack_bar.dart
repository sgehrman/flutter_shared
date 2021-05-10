import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_shared/src/widgets/snackbar/tap_bounce_container.dart';

Future<void> showTopSnackBar(
  BuildContext context,
  Widget child, {
  Duration showOutAnimationDuration = const Duration(milliseconds: 1000),
  Duration hideOutAnimationDuration = const Duration(milliseconds: 500),
  Duration displayDuration = const Duration(milliseconds: 2000),
  double additionalTopPadding = 16.0,
  VoidCallback onTap,
  OverlayState overlayState,
}) async {
  overlayState ??= Overlay.of(context);
  OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) {
      // looks weird on top of keyboard, and normally I want it on bottom
      // so only show on top if keyboard is visible
      return KeyboardVisibilityBuilder(
        builder: (context, isKeyboardVisible) {
          return TopSnackBar(
            onTop: isKeyboardVisible,
            onDismissed: () => overlayEntry.remove(),
            showOutAnimationDuration: showOutAnimationDuration,
            hideOutAnimationDuration: hideOutAnimationDuration,
            displayDuration: displayDuration,
            additionalTopPadding: additionalTopPadding,
            onTap: onTap,
            child: child,
          );
        },
      );
    },
  );

  if (overlayState != null) {
    overlayState.insert(overlayEntry);
  } else {
    print('showTopSnackBar: No overlay state');
  }
}

class TopSnackBar extends StatefulWidget {
  const TopSnackBar({
    @required this.child,
    @required this.onDismissed,
    @required this.showOutAnimationDuration,
    @required this.hideOutAnimationDuration,
    @required this.displayDuration,
    @required this.additionalTopPadding,
    this.onTap,
    this.onTop = false,
  });

  final Widget child;
  final VoidCallback onDismissed;
  final Duration showOutAnimationDuration;
  final Duration hideOutAnimationDuration;
  final Duration displayDuration;
  final double additionalTopPadding;
  final VoidCallback onTap;
  final bool onTop;

  @override
  _TopSnackBarState createState() => _TopSnackBarState();
}

class _TopSnackBarState extends State<TopSnackBar>
    with SingleTickerProviderStateMixin {
  Animation offsetAnimation;
  AnimationController animationController;
  double topPosition;

  @override
  void initState() {
    topPosition = widget.additionalTopPadding;
    _setupAndStartAnimation();
    super.initState();
  }

  Future<void> _setupAndStartAnimation() async {
    animationController = AnimationController(
      vsync: this,
      duration: widget.showOutAnimationDuration,
      reverseDuration: widget.hideOutAnimationDuration,
    );

    final Tween<Offset> offsetTween = Tween<Offset>(
      begin: Offset(0.0, widget.onTop ? -1.0 : 1.0),
      end: const Offset(0.0, 0.0),
    );

    offsetAnimation = offsetTween.animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.elasticOut,
        reverseCurve: Curves.linearToEaseOut,
      ),
    );

    offsetAnimation.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        await Future<dynamic>.delayed(widget.displayDuration);

        await animationController.reverse();
        if (mounted) {
          setState(() {
            topPosition = 0;
          });
        }
      }

      if (status == AnimationStatus.dismissed) {
        widget.onDismissed.call();
      }
    });

    await animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: widget.hideOutAnimationDuration * 1.5,
      curve: Curves.linearToEaseOut,
      top: widget.onTop ? topPosition : null,
      bottom: !widget.onTop ? topPosition : null,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: offsetAnimation as Animation<Offset>,
        child: SafeArea(
          child: TapBounceContainer(
            onTap: () {
              widget.onTap?.call();
              animationController.reverse();
            },
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

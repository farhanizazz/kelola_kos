import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoadingBar extends StatefulWidget {
  const LoadingBar({
    super.key,
    this.title,
    this.subtitle,
    this.titleStyle,
    this.subtitleStyle,
    this.color,
    this.backgroundColor,
    this.titleSpace,
  });

  final String? title;
  final TextStyle? titleStyle;
  final List<String?>? subtitle;
  final TextStyle? subtitleStyle;
  final Color? color;
  final Color? backgroundColor;
  final double? titleSpace;

  @override
  State<LoadingBar> createState() => _LoadingBarState();
}

class _LoadingBarState extends State<LoadingBar> {
  int _index = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        _index = (_index + 1) % (widget.subtitle?.length ?? 1);
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 34,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: widget.backgroundColor ?? Theme.of(context).colorScheme.surface,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 36,
            width: 36,
            child: CircularProgressIndicator(
              color: widget.color,
              strokeWidth: 4,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.title ?? 'Just a moment...',
                    style: widget.titleStyle ??
                        TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w700,
                        )),
                if (widget.subtitle != null && widget.subtitle!.isNotEmpty) ...[
                  SizedBox(height: widget.titleSpace ?? 4),
                  Text(widget.subtitle![_index]!,
                      style: widget.subtitleStyle ??
                          TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.secondary,
                          )),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

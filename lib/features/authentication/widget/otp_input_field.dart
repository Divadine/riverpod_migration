import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpInputField extends StatefulWidget {
  final int length;
  final ValueChanged<String> onChanged;

  /// change this value to clear all boxes (e.g. after resend)
  final int resetToken;

  const OtpInputField({
    super.key,
    this.length = 4,
    required this.onChanged,
    this.resetToken = 0,
  });

  @override
  State<OtpInputField> createState() => _OtpInputFieldState();
}

class _OtpInputFieldState extends State<OtpInputField> {
  late final List<TextEditingController> _ctrls;
  late final List<FocusNode> _nodes;

  @override
  void initState() {
    super.initState();
    _ctrls = List.generate(widget.length, (_) => TextEditingController());
    _nodes = List.generate(widget.length, (_) => FocusNode());
    for (final n in _nodes) {
      n.addListener(() {
        if (mounted) setState(() {});
      });
    }
  }

  @override
  void didUpdateWidget(covariant OtpInputField old) {
    super.didUpdateWidget(old);
    if (old.resetToken != widget.resetToken) {
      for (final c in _ctrls) {
        c.clear();
      }
      _nodes.first.requestFocus();
    }
  }

  @override
  void dispose() {
    for (final c in _ctrls) {
      c.dispose();
    }
    for (final n in _nodes) {
      n.dispose();
    }
    super.dispose();
  }

  void _notify() => widget.onChanged(_ctrls.map((c) => c.text).join());

  void _onChanged(String value, int i) {
    if (value.isNotEmpty && i < widget.length - 1) {
      _nodes[i + 1].requestFocus();
    } else if (value.isNotEmpty && i == widget.length - 1) {
      _nodes[i].unfocus();
    }
    setState(() {});
    _notify();
  }

  KeyEventResult _onKey(KeyEvent event, int i) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _ctrls[i].text.isEmpty &&
        i > 0) {
      _ctrls[i - 1].clear();
      _nodes[i - 1].requestFocus();
      _notify();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(widget.length, (i) {
        final active = _nodes[i].hasFocus || _ctrls[i].text.isNotEmpty;
        return SizedBox(
          width: 54,
          height: 54,
          child: Focus(
            onKeyEvent: (_, e) => _onKey(e, i),
            child: TextField(
              controller: _ctrls[i],
              focusNode: _nodes[i],
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(1),
              ],
              onChanged: (v) => _onChanged(v, i),
              style: const TextStyle(fontSize: 16),
              decoration: InputDecoration(
                counterText: '',
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: active ? Colors.black : Colors.grey,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.black),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
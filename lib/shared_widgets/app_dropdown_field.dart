// shared_widgets/app_dropdown_field.dart
import 'package:flutter/material.dart';
import '../core/theme/color.dart';
import 'app_text.dart';

class AppDropdownField<T> extends StatefulWidget {
  final T? value;
  final String hintText;
  final double? height;
  final List<T> items;
  final String Function(T) itemLabel;
  final void Function(T?)? onChanged;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? selectedItemColor;
  final Color? selectedItemTextColor;
  final double? menuHeight;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry? contentPadding;
  final bool hideSuffixIcon;
  final double borderRadius;

  const AppDropdownField({
    super.key,
    required this.value,
    required this.hintText,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
    this.backgroundColor,
    this.borderColor,
    this.selectedItemColor,
    this.selectedItemTextColor,
    this.menuHeight,
    this.suffixIcon,
    this.height,
    this.contentPadding,
    this.hideSuffixIcon = false,
    this.borderRadius = 12,
  });

  @override
  State<AppDropdownField<T>> createState() => _AppDropdownFieldState<T>();
}

class _AppDropdownFieldState<T> extends State<AppDropdownField<T>> {
  final MenuController menuController = MenuController();
  bool isOpen = false;

  void _toggleMenu() {
    if (menuController.isOpen) {
      menuController.close();
    } else {
      menuController.open();
    }
  }

  Widget _buildSuffixIcon() {
    //if (widget.hideSuffixIcon) return const SizedBox.shrink();
    return SizedBox(
      height: 30,
      width: 30,
      child: Center(
        child: widget.suffixIcon ??
            Icon(
              isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              size: 22,
              color: Colors.black,
            ),
      ),
    );
  }

  Widget _buildDisplayText() {
    final hasValue = widget.value != null;
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        hasValue ? widget.itemLabel(widget.value as T) : widget.hintText,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: appTextStyle(
          fontSize: 14,
          color: hasValue ? Colors.black : Colors.grey,
        ),
      ),
    );
  }

  OutlineInputBorder _border() {
    final color = isOpen
        ? Colors.black
        : (widget.borderColor ?? AppColors.fieldGrey.withAlpha(60));
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      borderSide: BorderSide(color: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedBg = widget.selectedItemColor ?? AppColors.red.withAlpha(30);
    final selectedFg = widget.selectedItemTextColor ?? AppColors.red;

    return LayoutBuilder(
      builder: (context, constraints) {
        return MenuAnchor(
          controller: menuController,
          alignmentOffset: const Offset(0, 6), // gap below the field
          onOpen: () {
            if (mounted) setState(() => isOpen = true);
          },
          onClose: () {
            if (mounted) setState(() => isOpen = false);
          },
          style: MenuStyle(
            minimumSize: WidgetStateProperty.all(Size(constraints.maxWidth, 0)),
            maximumSize: WidgetStateProperty.all(
              Size(constraints.maxWidth, widget.menuHeight ?? 300),
            ),
            padding: WidgetStateProperty.all(EdgeInsets.zero),
            elevation: WidgetStateProperty.all(2),
            backgroundColor: WidgetStateProperty.all(Colors.white),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
              ),
            ),
          ),
          menuChildren: widget.items.map((item) {
            final selected = item == widget.value;

            return MenuItemButton(
              style: ButtonStyle(
                minimumSize:
                WidgetStateProperty.all(Size(constraints.maxWidth, 48)),
                padding: WidgetStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 20),
                ),
                backgroundColor: WidgetStateProperty.resolveWith(
                      (states) => selected ? selectedBg : Colors.white,
                ),
                foregroundColor: WidgetStateProperty.resolveWith(
                      (states) => selected ? selectedFg : Colors.black,
                ),
                textStyle: WidgetStateProperty.all(appTextStyle(fontSize: 14)),
              ),
              onPressed: () {
                widget.onChanged?.call(item);
                menuController.close();
              },
              child: SizedBox(
                width: constraints.maxWidth - 40,
                child: Text(widget.itemLabel(item)),
              ),
            );
          }).toList(),
          builder: (context, controller, child) {
            final field = GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: widget.onChanged == null ? null : _toggleMenu,
              child: AbsorbPointer(
                child: InputDecorator(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: widget.backgroundColor ?? Colors.white,
                    isDense: true,
                    contentPadding: widget.contentPadding ??
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    enabledBorder: _border(),
                    focusedBorder: _border(),
                    border: _border(),
                    suffixIcon: widget.hideSuffixIcon
                        ? null
                        : Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: _buildSuffixIcon(),
                    ),
                  ),
                  child: _buildDisplayText(),
                ),
              ),
            );

            return widget.height != null
                ? SizedBox(height: widget.height, child: field)
                : field;
          },
        );
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'package:artcollab_mobile/core/theme/app_theme.dart';

class ElegantFormField extends StatefulWidget {
  final String label;
  final String? hint;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int maxLines;
  final int? maxLength;
  final bool enabled;
  final VoidCallback? onTap;
  final bool readOnly;
  final String? initialValue;
  final void Function(String)? onChanged;
  final FocusNode? focusNode;

  const ElegantFormField({
    super.key,
    required this.label,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.controller,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
    this.onTap,
    this.readOnly = false,
    this.initialValue,
    this.onChanged,
    this.focusNode,
  });

  @override
  State<ElegantFormField> createState() => _ElegantFormFieldState();
}

class _ElegantFormFieldState extends State<ElegantFormField>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onFocusChange(bool hasFocus) {
    setState(() => _isFocused = hasFocus);
    if (hasFocus) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                boxShadow: _isFocused
                    ? [
                        BoxShadow(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Focus(
                onFocusChange: _onFocusChange,
                child: TextFormField(
                  controller: widget.controller,
                  validator: widget.validator,
                  keyboardType: widget.keyboardType,
                  obscureText: widget.obscureText,
                  maxLines: widget.maxLines,
                  maxLength: widget.maxLength,
                  enabled: widget.enabled,
                  onTap: widget.onTap,
                  readOnly: widget.readOnly,
                  initialValue: widget.initialValue,
                  onChanged: widget.onChanged,
                  focusNode: widget.focusNode,
                  style: context.textTheme.bodyLarge,
                  decoration: InputDecoration(
                    labelText: widget.label,
                    hintText: widget.hint,
                    prefixIcon: widget.prefixIcon != null
                        ? Icon(
                            widget.prefixIcon,
                            color: _isFocused
                                ? AppTheme.primaryColor
                                : Colors.grey.shade600,
                          )
                        : null,
                    suffixIcon: widget.suffixIcon != null
                        ? IconButton(
                            icon: Icon(
                              widget.suffixIcon,
                              color: _isFocused
                                  ? AppTheme.primaryColor
                                  : Colors.grey.shade600,
                            ),
                            onPressed: widget.onSuffixTap,
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppTheme.borderRadiusMedium),
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppTheme.borderRadiusMedium),
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppTheme.borderRadiusMedium),
                      borderSide: const BorderSide(
                        color: AppTheme.primaryColor,
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppTheme.borderRadiusMedium),
                      borderSide: const BorderSide(
                        color: AppTheme.errorColor,
                        width: 1.5,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppTheme.borderRadiusMedium),
                      borderSide: const BorderSide(
                        color: AppTheme.errorColor,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: _isFocused
                        ? AppTheme.primaryColor.withOpacity(0.02)
                        : Colors.grey.shade50,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingMedium,
                      vertical: AppTheme.spacingMedium,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

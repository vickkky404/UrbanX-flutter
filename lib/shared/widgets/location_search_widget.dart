import 'package:flutter/material.dart';

class LocationSearchWidget extends StatefulWidget {
  final String placeholder;
  final ValueChanged<String> onChanged;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final String? prefixText;

  const LocationSearchWidget({
    super.key,
    required this.placeholder,
    required this.onChanged,
    this.onTap,
    this.controller,
    this.prefixText,
  });

  @override
  State<LocationSearchWidget> createState() => _LocationSearchWidgetState();
}

class _LocationSearchWidgetState extends State<LocationSearchWidget> {
  late TextEditingController _controller;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_updateHasText);
  }

  void _updateHasText() {
    setState(() {
      _hasText = _controller.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    } else {
      _controller.removeListener(_updateHasText);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        onChanged: widget.onChanged,
        onTap: widget.onTap,
        decoration: InputDecoration(
          hintText: widget.placeholder,
          prefixIcon: Icon(
            Icons.location_on,
            color: const Color(0xFF6750A4),
          ),
          suffixIcon: _hasText
              ? GestureDetector(
                  onTap: () {
                    _controller.clear();
                    widget.onChanged('');
                  },
                  child: const Icon(
                    Icons.close,
                    color: Colors.grey,
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: 16,
          ),
        ),
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }
}


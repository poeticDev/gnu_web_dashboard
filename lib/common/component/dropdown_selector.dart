
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

class DropdownSelector extends StatelessWidget {
  final DropdownSearchOnFind<String>? items;
  final ValueChanged<List<String>> onChanged;
  final String label;

  const DropdownSelector({
    super.key,
    required this.items,
    required this.onChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6.0),
        DropdownSearch<String>.multiSelection(
          mode: Mode.form,
          items: items,
          onChanged: onChanged,
          popupProps: const PopupPropsMultiSelection.menu(
            showSelectedItems: true,
          ),
        ),
      ],
    );
  }
}

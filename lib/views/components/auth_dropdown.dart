import 'package:flutter/material.dart';

class AuthDropdown extends StatelessWidget {
  const AuthDropdown({
    super.key,
    required this.icon,
    required this.title,
    required this.items,
    required this.onSelect,
    required this.selectedValue,
  });

  final IconData icon;
  final String title;
  final String selectedValue;
  final List<String> items;
  final void Function(String?) onSelect;

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ListTile(
        leading: Icon(
          icon,
          color: cs.onBackground,
        ),
        title: Text(
          title,
          style: tt.titleMedium!.copyWith(color: cs.onBackground),
        ),
        trailing: DropdownButton<String>(
          value: selectedValue,
          items: items
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: tt.titleSmall!.copyWith(overflow: TextOverflow.ellipsis, color: cs.onSurface),
                  ),
                ),
              )
              .toList(),
          onChanged: onSelect,
          style: tt.titleLarge!.copyWith(color: cs.onSurface),
        ),
        // shape: RoundedRectangleBorder(
        //   side: BorderSide(width: 1, color: cs.onBackground.withOpacity(0.6)),
        //   borderRadius: BorderRadius.circular(5),
        // ),
      ),
    );
  }
}

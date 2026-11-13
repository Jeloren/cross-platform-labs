import 'package:material_ui/material_ui.dart';

// Верхняя панель экрана.
class AppAppbar extends StatelessWidget implements PreferredSizeWidget {
  const AppAppbar({super.key, required this.title});

  final Widget title;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(title: title);
  }
}

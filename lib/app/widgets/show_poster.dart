import 'package:material_ui/material_ui.dart';

// Постер или заглушка, если изображение недоступно.
class ShowPoster extends StatelessWidget {
  const ShowPoster({
    super.key,
    required this.image,
    required this.width,
    required this.height,
  });
  final String image;
  final double width;
  final double height;

  Widget _placeholder() => Container(
    width: width,
    height: height,
    color: Colors.grey.shade200,
    child: const Icon(Icons.movie_outlined, color: Colors.grey),
  );

  @override
  Widget build(BuildContext context) {
    if (image.isEmpty) return _placeholder();
    if (image.startsWith('https://') || image.startsWith('http://')) {
      return Image.network(
        image,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _placeholder(),
      );
    }
    return Image.asset(
      image,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => _placeholder(),
    );
  }
}

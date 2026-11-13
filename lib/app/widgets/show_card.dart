import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../data/data.dart';
import '../extensions/extensions.dart';
import '../theme/theme.dart';

// Карточка сериала в списке.
class ShowCard extends StatelessWidget {
  const ShowCard({super.key, required this.show});

  final Show show;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ThemeColors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () => context.push('/show/${show.id}'),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SizedBox(
            height: 132,
            child: Row(
              spacing: 14,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    show.image,
                    width: 92,
                    height: 132,
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        show.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      4.ph,
                      Text(
                        '${show.year} · ${show.genres.join(' · ')}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      8.ph,
                      Expanded(
                        child: Text(
                          show.description,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 18,
                            color: Colors.amber,
                          ),
                          4.pw,
                          Text(
                            show.rating.toStringAsFixed(1),
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: ThemeColors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

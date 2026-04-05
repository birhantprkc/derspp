import 'package:flutter/material.dart';

class ActivityHeatmap extends StatefulWidget {
  final Map<DateTime, int> data;
  final int weeks;

  const ActivityHeatmap({super.key, required this.data, this.weeks = 12});

  @override
  State<ActivityHeatmap> createState() => _ActivityHeatmapState();
}

class _ActivityHeatmapState extends State<ActivityHeatmap> {
  DateTime? _hoveredDay;

  @override
  Widget build(BuildContext context) {
    final cells = _buildCells();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final emptyColor = isDark
        ? Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3)
        : Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.4);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMonthLabels(cells),
        const SizedBox(height: 8),
        _buildGrid(cells, emptyColor),
        if (_hoveredDay != null) ...[
          const SizedBox(height: 12),
          _buildTooltip(),
        ],
        const SizedBox(height: 12),
        _buildLegend(emptyColor),
      ],
    );
  }

  List<_HeatmapCell> _buildCells() {
    final today = DateTime.now();
    final todayNorm = DateTime(today.year, today.month, today.day);

    final currentMonday = todayNorm.subtract(
      Duration(days: todayNorm.weekday - 1),
    );

    final startDay = currentMonday.subtract(
      Duration(days: (widget.weeks - 1) * 7),
    );

    final cells = <_HeatmapCell>[];
    final totalDays = widget.weeks * 7;

    for (int i = 0; i < totalDays; i++) {
      final day = startDay.add(Duration(days: i));
      if (day.isAfter(todayNorm)) {
        cells.add(_HeatmapCell(date: day, count: -1));
      } else {
        final count = widget.data[day] ?? 0;
        cells.add(_HeatmapCell(date: day, count: count));
      }
    }
    return cells;
  }

  Widget _buildGrid(List<_HeatmapCell> cells, Color emptyColor) {
    final maxCount = cells.fold<int>(0, (m, c) => c.count > m ? c.count : m);
    final primary = Theme.of(context).colorScheme.primary;

    final columns = <List<_HeatmapCell>>[];
    for (int i = 0; i < cells.length; i += 7) {
      final end = (i + 7 < cells.length) ? i + 7 : cells.length;
      columns.add(cells.sublist(i, end));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final cellSize =
            ((constraints.maxWidth - 28 - (columns.length - 1) * 4) /
                    columns.length)
                .clamp(8.0, 16.0);

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 24, child: _buildDayLabels(cellSize)),
            const SizedBox(width: 8),
            ...columns.map((col) {
              return Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Column(
                  children: col.map((cell) {
                    if (cell.count == -1) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: SizedBox(width: cellSize, height: cellSize),
                      );
                    }
                    final color = _cellColor(
                      cell.count,
                      maxCount,
                      emptyColor,
                      primary,
                    );
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _hoveredDay = _hoveredDay == cell.date
                              ? null
                              : cell.date;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Container(
                          width: cellSize,
                          height: cellSize,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(2),
                            border: _hoveredDay == cell.date
                                ? Border.all(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                    width: 1,
                                  )
                                : null,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            }).toList(),
          ],
        );
      },
    );
  }

  Color _cellColor(int count, int maxCount, Color emptyColor, Color primary) {
    if (count == 0) return emptyColor;
    final ratio = maxCount > 0 ? count / maxCount : 0.0;
    if (ratio <= 0.2) return primary.withOpacity(0.15);
    if (ratio <= 0.4) return primary.withOpacity(0.35);
    if (ratio <= 0.6) return primary.withOpacity(0.55);
    if (ratio <= 0.8) return primary.withOpacity(0.75);
    return primary;
  }

  Widget _buildMonthLabels(List<_HeatmapCell> cells) {
    final columns = <DateTime>[];
    for (int i = 0; i < cells.length; i += 7) {
      columns.add(cells[i].date);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final cellSize =
            ((constraints.maxWidth - 28 - (columns.length - 1) * 3) /
                    columns.length)
                .clamp(8.0, 18.0);

        final labels = <Widget>[const SizedBox(width: 28)];
        String? lastMonth;

        for (int i = 0; i < columns.length; i++) {
          final monthStr = _monthAbbr(columns[i].month);
          if (monthStr != lastMonth) {
            labels.add(
              SizedBox(
                width: cellSize + 3,
                child: Text(
                  monthStr,
                  style: TextStyle(
                    fontSize: 9,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                  overflow: TextOverflow.visible,
                ),
              ),
            );
            lastMonth = monthStr;
          } else {
            labels.add(SizedBox(width: cellSize + 3));
          }
        }

        return Row(children: labels);
      },
    );
  }

  Widget _buildDayLabels(double cellSize) {
    const days = ['Pzt', '', 'Çar', '', 'Cum', '', 'Paz'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: days.map((d) {
        return SizedBox(
          height: cellSize + 3,
          child: Text(
            d,
            style: TextStyle(
              fontSize: 8,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTooltip() {
    final day = _hoveredDay!;
    final count = widget.data[day] ?? 0;
    final label = count == 0 ? 'Aktivite yok' : '$count tekrar';
    final dateStr = '${day.day} ${_monthName(day.month)} ${day.year}';

    return Text(
      '$dateStr: $label',
      style: TextStyle(
        fontSize: 11,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
      ),
    );
  }

  Widget _buildLegend(Color emptyColor) {
    final primary = Theme.of(context).colorScheme.primary;
    final legendColors = [
      emptyColor,
      primary.withValues(alpha: 0.25),
      primary.withValues(alpha: 0.50),
      primary.withValues(alpha: 0.75),
      primary,
    ];
    return Row(
      children: [
        Text(
          'Az',
          style: TextStyle(
            fontSize: 9,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.4),
          ),
        ),
        const SizedBox(width: 4),
        ...legendColors.map(
          (c) => Padding(
            padding: const EdgeInsets.only(right: 3),
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: c,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
        Text(
          'Çok',
          style: TextStyle(
            fontSize: 9,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.4),
          ),
        ),
      ],
    );
  }

  String _monthAbbr(int month) {
    const abbrs = [
      'Oca',
      'Şub',
      'Mar',
      'Nis',
      'May',
      'Haz',
      'Tem',
      'Ağu',
      'Eyl',
      'Eki',
      'Kas',
      'Ara',
    ];
    return abbrs[month - 1];
  }

  String _monthName(int month) {
    const names = [
      'Ocak',
      'Şubat',
      'Mart',
      'Nisan',
      'Mayıs',
      'Haziran',
      'Temmuz',
      'Ağustos',
      'Eylül',
      'Ekim',
      'Kasım',
      'Aralık',
    ];
    return names[month - 1];
  }
}

class _HeatmapCell {
  final DateTime date;
  final int count;
  const _HeatmapCell({required this.date, required this.count});
}

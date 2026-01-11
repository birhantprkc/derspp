import 'package:flutter/material.dart';
import 'library_screen.dart';
import 'publisher_screen.dart';
import 'package:provider/provider.dart';
import '../../providers/book_provider.dart';

class SolutionScreen extends StatefulWidget {
  const SolutionScreen({super.key});

  @override
  State<SolutionScreen> createState() => _SolutionScreenState();
}

class _SolutionScreenState extends State<SolutionScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bookProvider = Provider.of<BookProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Kitap ara...',
                  border: InputBorder.none,
                ),
                onChanged: (value) => bookProvider.setSearchQuery(value),
              )
            : const Text('Video çözüm'),
        titleTextStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          fontSize: 20,
        ),
        actions: [
          if (_tabController.index == 0) ...[
            IconButton(
              icon: Icon(_isSearching ? Icons.close : Icons.search),
              onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                  if (!_isSearching) {
                    _searchController.clear();
                    bookProvider.setSearchQuery('');
                  }
                });
              },
            ),
            IconButton(
              icon: Icon(
                bookProvider.isGridView ? Icons.grid_view : Icons.list,
              ),
              onPressed: () =>
                  bookProvider.setGridView(!bookProvider.isGridView),
            ),
          ],
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 250),
              child: TabBar(
                controller: _tabController,
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(text: 'Kütüphane'),
                  Tab(text: 'Yayınlar'),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Divider(
            height: 1,
            thickness: 1,
            color: theme.colorScheme.outlineVariant.withOpacity(0.5),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [LibraryScreen(), PublisherScreen()],
            ),
          ),
        ],
      ),
    );
  }
}

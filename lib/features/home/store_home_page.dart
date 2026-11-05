import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../theme/nova_theme.dart';
import '../product/product_detail_page.dart';
import '../profile/profile_page.dart';
import '../product/product_card.dart';

class StoreHomePage extends StatefulWidget {
  const StoreHomePage({super.key});

  @override
  State<StoreHomePage> createState() => _StoreHomePageState();
}

class _StoreHomePageState extends State<StoreHomePage> {
  final _searchController = TextEditingController();
  final Set<String> _favorites = {};
  String _query = '';
  String? _category;
  int _cartCount = 2;
  int _tab = 0;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visibleProducts = storeProducts.where((product) {
      final matchesSearch = product.name.toLowerCase().contains(
        _query.toLowerCase(),
      );
      return matchesSearch &&
          (_category == null || product.category == _category);
    }).toList();

    return Scaffold(
      body: _tab == 4
          ? const ProfilePage()
          : SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              floating: false,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white.withValues(alpha: .96),
              surfaceTintColor: Colors.transparent,
              toolbarHeight: 60,
              titleSpacing: 16,
              title: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: novaGreen,
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: const Icon(
                      Icons.storefront_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 9),
                  const Text(
                    'NOVA STORE',
                    style: TextStyle(
                      color: novaInk,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -.5,
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  tooltip: 'Notifikasi',
                  onPressed: () => _showMessage('Belum ada notifikasi baru'),
                  icon: const Badge(
                    smallSize: 8,
                    backgroundColor: novaGreen,
                    child: Icon(Icons.notifications_none_rounded, color: novaInk),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 112),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildSearch(),
                  const SizedBox(height: 20),
                  _buildPromo(),
                  const SizedBox(height: 24),
                  _buildCategories(),
                  const SizedBox(height: 26),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _category == null ? 'Produk Pilihan' : _category!,
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                            color: novaInk,
                          ),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => setState(() => _category = null),
                        iconAlignment: IconAlignment.end,
                        label: const Text('Lihat Semua'),
                        icon: const Icon(Icons.chevron_right, size: 18),
                        style: TextButton.styleFrom(
                          foregroundColor: novaGreen,
                          padding: EdgeInsets.zero,
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (visibleProducts.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 36),
                      child: Center(
                        child: Text(
                          'Produk tidak ditemukan',
                          style: TextStyle(color: novaMuted),
                        ),
                      ),
                    )
                  else
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final width = (constraints.maxWidth - 12) / 2;
                        return Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: visibleProducts
                              .map(
                                (product) => SizedBox(
                                  width: width,
                                  child: ProductCard(
                                    product: product,
                                    favorite: _favorites.contains(product.name),
                                    onFavorite: () => setState(() {
                                      _favorites.contains(product.name)
                                          ? _favorites.remove(product.name)
                                          : _favorites.add(product.name);
                                    }),
                                    onAdd: () => setState(() => _cartCount++),
                                    onOpen: () => Navigator.of(context).push(
                                      MaterialPageRoute<void>(
                                        builder: (_) => ProductDetailPage(
                                          product: product,
                                          onAddToCart: () =>
                                              setState(() => _cartCount++),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        );
                      },
                    ),
                ]),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildNavigation(),
    );
  }

  Widget _buildSearch() => Container(
    height: 50,
    padding: const EdgeInsets.symmetric(horizontal: 13),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: novaLine),
      boxShadow: const [
        BoxShadow(
          color: Color(0x090B1C30),
          blurRadius: 8,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      children: [
        const Icon(Icons.search_rounded, color: Color(0xFF758078), size: 22),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: _searchController,
            onChanged: (value) => setState(() => _query = value),
            decoration: const InputDecoration(
              hintText: 'Cari produk favoritmu...',
              hintStyle: TextStyle(color: Color(0xFF89948D), fontSize: 14),
              border: InputBorder.none,
              isCollapsed: true,
            ),
            style: const TextStyle(fontSize: 14, color: novaInk),
          ),
        ),
        IconButton(
          visualDensity: VisualDensity.compact,
          tooltip: 'Filter kategori',
          onPressed: () => _showCategoryPicker(),
          icon: const Icon(Icons.tune_rounded, color: novaGreen, size: 21),
        ),
      ],
    ),
  );

  Widget _buildPromo() => ClipRRect(
    borderRadius: BorderRadius.circular(19),
    child: SizedBox(
      height: 186,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=1200&q=85',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                Container(color: const Color(0xFF64776B)),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Color(0xD90B1C30)],
                stops: [.15, 1],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(19),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF85F8C4),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'SPESIAL MUSIM INI',
                    style: TextStyle(
                      color: Color(0xFF002114),
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Temukan Favoritmu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Koleksi kurasi eksklusif dengan penawaran istimewa.',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: () => setState(() => _category = null),
                  icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                  label: const Text('Belanja Sekarang'),
                  style: FilledButton.styleFrom(
                    backgroundColor: novaGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 9,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  Widget _buildCategories() {
    const categories = [
      ('Fashion', Icons.checkroom_rounded),
      ('Elektronik', Icons.headphones_rounded),
      ('Aksesori', Icons.watch_rounded),
      ('Lainnya', Icons.grid_view_rounded),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Kategori',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            color: novaInk,
          ),
        ),
        const SizedBox(height: 13),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: categories.map((entry) {
            final selected = _category == entry.$1;
            return GestureDetector(
              onTap: () => setState(
                () => _category = selected || entry.$1 == 'Lainnya'
                    ? null
                    : entry.$1,
              ),
              child: SizedBox(
                width: 72,
                child: Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: selected
                            ? const Color(0xFFE0F4EA)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(17),
                        border: Border.all(color: selected ? novaGreen : novaLine),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x080B1C30),
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        entry.$2,
                        color: selected ? novaGreen : novaInk,
                        size: 25,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      entry.$1,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: selected
                            ? FontWeight.w800
                            : FontWeight.w600,
                        color: selected ? novaGreen : novaInk,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildNavigation() {
    const items = [
      (Icons.home_rounded, 'Beranda'),
      (Icons.explore_outlined, 'Jelajah'),
      (Icons.shopping_cart_outlined, 'Keranjang'),
      (Icons.receipt_long_outlined, 'Pesanan'),
      (Icons.person_outline_rounded, 'Profil'),
    ];
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x100B1C30),
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 66,
          child: Row(
            children: List.generate(items.length, (index) {
              final active = _tab == index;
              final item = items[index];
              return Expanded(
                child: InkWell(
                  onTap: () => setState(() => _tab = index),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (index == 2)
                        Badge(
                          isLabelVisible: _cartCount > 0,
                          label: Text('$_cartCount'),
                          backgroundColor: novaGreen,
                          child: Icon(
                            item.$1,
                            color: active ? novaGreen : novaMuted,
                            size: 23,
                          ),
                        )
                      else
                        Icon(
                          item.$1,
                          color: active ? novaGreen : novaMuted,
                          size: 23,
                        ),
                      const SizedBox(height: 4),
                      Text(
                        item.$2,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: active
                              ? FontWeight.w800
                              : FontWeight.w500,
                          color: active ? novaGreen : novaMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  void _showCategoryPicker() {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Pilih kategori',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ...['Semua', 'Fashion', 'Elektronik', 'Aksesori'].map(
              (name) => ListTile(
                title: Text(name),
                trailing:
                    ((_category == null && name == 'Semua') ||
                        _category == name)
                    ? const Icon(Icons.check, color: novaGreen)
                    : null,
                onTap: () {
                  setState(() => _category = name == 'Semua' ? null : name);
                  Navigator.pop(context);
                },
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showMessage(String message) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 1),
        ),
      );
}


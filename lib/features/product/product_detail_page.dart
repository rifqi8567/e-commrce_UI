import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../theme/nova_theme.dart';
import '../../utils/format_price.dart';
import '../checkout/checkout_page.dart';
import 'product_card.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({
    super.key,
    required this.product,
    required this.onAddToCart,
  });
  final Product product;
  final VoidCallback onAddToCart;

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final List<(String, Color)> _colors = const [
    ('Putih Klasik', Color(0xFFF8FAFC)),
    ('Abu-abu', Color(0xFF64748B)),
    ('Biru Navy', Color(0xFF1E293B)),
    ('Hijau Zaitun', Color(0xFF475569)),
  ];
  String _selectedColor = 'Putih Klasik';
  int _selectedSize = 41;
  int _quantity = 1;
  bool _favorite = false;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final oldPrice = (product.price * 1.23).round();
    return Scaffold(
      backgroundColor: novaSurface,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white.withValues(alpha: .97),
              surfaceTintColor: Colors.transparent,
              toolbarHeight: 56,
              titleSpacing: 8,
              title: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_rounded, color: novaInk),
                  ),
                  const Text(
                    'Detail Produk',
                    style: TextStyle(
                      color: novaInk,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  tooltip: 'Bagikan',
                  onPressed: () => _message('Bagikan produk ${product.name}'),
                  icon: const Icon(
                    Icons.share_outlined,
                    color: novaMuted,
                    size: 21,
                  ),
                ),
                IconButton(
                  tooltip: 'Keranjang belanja',
                  onPressed: () =>
                      _message('Produk di keranjang: ${_quantity}'),
                  icon: Badge(
                    label: const Text('2'),
                    backgroundColor: novaGreen,
                    child: const Icon(
                      Icons.shopping_cart_outlined,
                      color: novaInk,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
              ],
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _gallery(),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _infoCard(product, oldPrice),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _variantCard(),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _descriptionCard(),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _deliveryCard(),
                  ),
                  const SizedBox(height: 20),
                  _relatedProducts(),
                  const SizedBox(height: 112),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _actionBar(),
    );
  }

  Widget _gallery() => AspectRatio(
    aspectRatio: 1.04,
    child: Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          widget.product.image,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: const Color(0xFFE7EDF2),
            child: const Icon(
              Icons.image_not_supported_outlined,
              size: 48,
              color: novaMuted,
            ),
          ),
        ),
        Positioned(
          top: 16,
          left: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .88),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified_rounded, color: novaGreen, size: 15),
                SizedBox(width: 5),
                Text(
                  'Original',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: novaInk,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 13,
          right: 14,
          child: Material(
            color: Colors.white.withValues(alpha: .94),
            shape: const CircleBorder(),
            child: IconButton(
              onPressed: () => setState(() => _favorite = !_favorite),
              icon: Icon(
                _favorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                color: _favorite ? Colors.redAccent : novaGreen,
                size: 21,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 14,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .86),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 16,
                    height: 6,
                    decoration: BoxDecoration(
                      color: novaGreen,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(width: 5),
                  ...List.generate(
                    2,
                    (_) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFFBCCAC0),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );

  Widget _infoCard(Product product, int oldPrice) => _card(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                product.category == 'Fashion'
                    ? 'Sneakers Pria'
                    : product.category,
                style: const TextStyle(
                  color: novaMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: .7,
                ),
              ),
            ),
            const Icon(Icons.star_rounded, size: 16, color: Color(0xFFF5A623)),
            const SizedBox(width: 3),
            Text(
              product.rating,
              style: const TextStyle(
                color: novaInk,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '(${product.reviews})',
              style: const TextStyle(color: novaMuted, fontSize: 11),
            ),
          ],
        ),
        const SizedBox(height: 7),
        Text(
          product.name,
          style: const TextStyle(
            fontSize: 21,
            height: 1.25,
            color: novaInk,
            fontWeight: FontWeight.w800,
            letterSpacing: -.4,
          ),
        ),
        const SizedBox(height: 9),
        Row(
          children: [
            Text(
              formatPrice(product.price),
              style: const TextStyle(
                fontSize: 20,
                color: novaInk,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(width: 9),
            Text(
              formatPrice(oldPrice),
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF89948D),
                decoration: TextDecoration.lineThrough,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFFE5E2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                '-19%',
                style: TextStyle(
                  color: Color(0xFFBA1A1A),
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _variantCard() => _card(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Warna',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: novaInk,
              ),
            ),
            const Spacer(),
            Text(
              _selectedColor,
              style: const TextStyle(color: novaMuted, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 11),
        Row(
          children: _colors
              .map(
                (option) => GestureDetector(
                  onTap: () => setState(() => _selectedColor = option.$1),
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _selectedColor == option.$1
                            ? novaGreen
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: option.$2,
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFCAD2D9)),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 14),
          child: Divider(height: 1, color: Color(0xFFE5EEFF)),
        ),
        Row(
          children: [
            const Text(
              'Ukuran (EU)',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: novaInk,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: _sizeGuide,
              style: TextButton.styleFrom(
                foregroundColor: novaMuted,
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
              ),
              child: const Text(
                'Panduan Ukuran',
                style: TextStyle(fontSize: 11),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          children: [39, 40, 41, 42, 43, 44].map((size) {
            final disabled = size == 44;
            final selected = _selectedSize == size;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 5),
                child: SizedBox(
                  height: 37,
                  child: OutlinedButton(
                    onPressed: disabled
                        ? null
                        : () => setState(() => _selectedSize = size),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor: selected ? novaGreen : Colors.white,
                      foregroundColor: selected ? Colors.white : novaInk,
                      disabledForegroundColor: const Color(0xFFABB3BC),
                      side: BorderSide(
                        color: selected ? novaGreen : const Color(0xFFE5EEFF),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      '$size',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: selected
                            ? FontWeight.w800
                            : FontWeight.w600,
                        decoration: disabled
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 14),
          child: Divider(height: 1, color: Color(0xFFE5EEFF)),
        ),
        Row(
          children: [
            const Text(
              'Jumlah',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: novaInk,
              ),
            ),
            const Spacer(),
            _quantityButton(Icons.remove, () {
              if (_quantity > 1) setState(() => _quantity--);
            }),
            SizedBox(
              width: 36,
              child: Center(
                child: Text(
                  '$_quantity',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            _quantityButton(Icons.add, () => setState(() => _quantity++)),
          ],
        ),
      ],
    ),
  );

  Widget _quantityButton(IconData icon, VoidCallback onTap) => SizedBox(
    width: 31,
    height: 31,
    child: IconButton(
      onPressed: onTap,
      padding: EdgeInsets.zero,
      style: IconButton.styleFrom(
        backgroundColor: const Color(0xFFF4F7FB),
        foregroundColor: novaMuted,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      icon: Icon(icon, size: 17),
    ),
  );

  Widget _descriptionCard() => _card(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Deskripsi Produk',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: novaInk,
          ),
        ),
        const SizedBox(height: 9),
        const Text(
          'Produk pilihan dengan material premium dan detail yang dirancang untuk kenyamanan penggunaan sehari-hari. Desain minimalis yang mudah dipadukan untuk berbagai aktivitas.',
          style: TextStyle(fontSize: 13, height: 1.55, color: novaMuted),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Divider(height: 1, color: Color(0xFFE5EEFF)),
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ProductSpec(label: 'Material', value: 'Canvas & Suede'),
            ProductSpec(label: 'Sol Luar', value: 'Thermo Rubber'),
            ProductSpec(label: 'Berat Bersih', value: '650 gram'),
          ],
        ),
      ],
    ),
  );

  Widget _deliveryCard() => Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(13),
    child: InkWell(
      onTap: () =>
          _message('Estimasi tarif dan pilihan kurir tersedia saat checkout.'),
      borderRadius: BorderRadius.circular(13),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: const Color(0xFFE5EEFF)),
        ),
        child: const Row(
          children: [
            Icon(Icons.local_shipping_outlined, color: novaGreen, size: 22),
            SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pengiriman 1–2 hari kerja',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: novaInk,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'Estimasi tarif dan opsi kurir saat checkout',
                    style: TextStyle(fontSize: 10, color: novaMuted),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: novaMuted, size: 20),
          ],
        ),
      ),
    ),
  );

  Widget _relatedProducts() {
    final related = storeProducts
        .where((product) => product.name != widget.product.name)
        .take(2)
        .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 11),
            child: Text(
              'Produk Serupa',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: novaInk,
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: related.map((product) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ProductCard(
                    product: product,
                    favorite: false,
                    onFavorite: () {},
                    onAdd: widget.onAddToCart,
                    onOpen: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute<void>(
                          builder: (_) => ProductDetailPage(
                            product: product,
                            onAddToCart: widget.onAddToCart,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _actionBar() => Container(
    decoration: const BoxDecoration(
      color: Colors.white,
      border: Border(top: BorderSide(color: Color(0xFFE5EEFF))),
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
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
        child: Row(
          children: [
            SizedBox(
              width: 44,
              height: 44,
              child: OutlinedButton(
                onPressed: () => _message('Chat dengan toko'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  foregroundColor: novaMuted,
                  side: const BorderSide(color: Color(0xFFE5EEFF)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                ),
                child: const Icon(Icons.chat_bubble_outline_rounded, size: 20),
              ),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: SizedBox(
                height: 44,
                child: OutlinedButton.icon(
                  onPressed: _addToCart,
                  icon: const Icon(Icons.shopping_bag_outlined, size: 17),
                  label: const Text('+ Keranjang'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: novaGreen,
                    side: const BorderSide(color: novaGreen),
                    backgroundColor: const Color(0xFFF3FAF6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: SizedBox(
                height: 44,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => CheckoutPage(
                        product: widget.product,
                        quantity: _quantity,
                        color: _selectedColor,
                        size: _selectedSize,
                      ),
                    ),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: novaGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  child: const Text('Beli Sekarang'),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _card({required Widget child}) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: const Color(0xFFE5EEFF)),
      boxShadow: const [
        BoxShadow(
          color: Color(0x080B1C30),
          blurRadius: 8,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: child,
  );

  void _addToCart() {
    for (var i = 0; i < _quantity; i++) {
      widget.onAddToCart();
    }
    _message('$_quantity produk ditambahkan ke keranjang');
  }

  void _message(String text) => ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 1),
    ),
  );
  void _sizeGuide() => showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Panduan Ukuran'),
      content: const Text(
        'Pilih ukuran EU yang biasa Anda gunakan. Jika berada di antara dua ukuran, pilih ukuran yang lebih besar.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Mengerti'),
        ),
      ],
    ),
  );
}

class ProductSpec extends StatelessWidget {
  const ProductSpec({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF89948D))),
      const SizedBox(height: 4),
      Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: novaInk)),
    ],
  );
}


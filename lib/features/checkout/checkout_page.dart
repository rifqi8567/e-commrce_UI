import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../theme/nova_theme.dart';
import '../../utils/format_price.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({
    super.key,
    required this.product,
    required this.quantity,
    required this.color,
    required this.size,
  });

  final Product product;
  final int quantity;
  final String color;
  final int size;

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  static const int _shippingCost = 15000;
  final _noteController = TextEditingController();
  String _paymentMethod = 'Transfer Bank Manual';
  String _recipient = 'Rifqi';
  String _phone = '08xxxxxxxxxx';
  String _address = 'Jl. Contoh No. 12, Bekasi, Jawa Barat';

  int get _subtotal => widget.product.price * widget.quantity;
  int get _total => _subtotal + _shippingCost;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: novaSurface,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          tooltip: 'Kembali',
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded, color: novaInk),
        ),
        title: const Text(
          'Checkout',
          style: TextStyle(
            color: novaInk,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: [
                Icon(Icons.verified_user_rounded, color: novaGreen, size: 16),
                SizedBox(width: 5),
                Text(
                  'Enkripsi 256-bit',
                  style: TextStyle(
                    color: novaGreen,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 124),
        children: [
          _addressCard(),
          const SizedBox(height: 13),
          _orderCard(),
          const SizedBox(height: 13),
          _shippingAndNoteCard(),
          const SizedBox(height: 13),
          _paymentCard(),
          const SizedBox(height: 13),
          _paymentSummaryCard(),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_rounded, color: novaGreen, size: 15),
              SizedBox(width: 5),
              Text(
                'Transaksi Terenkripsi',
                style: TextStyle(color: novaMuted, fontSize: 10),
              ),
              SizedBox(width: 12),
              Text('•', style: TextStyle(color: novaLine)),
              SizedBox(width: 12),
              Icon(Icons.check_circle_rounded, color: novaGreen, size: 15),
              SizedBox(width: 5),
              Text(
                '100% Produk Asli',
                style: TextStyle(color: novaMuted, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: _checkoutBar(),
    );
  }

  Widget _addressCard() => _checkoutCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.local_shipping_outlined, color: novaGreen, size: 21),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Alamat Pengiriman',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: novaInk,
                ),
              ),
            ),
            TextButton(onPressed: _editAddress, child: const Text('Ubah')),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: Color(0xFFE4F8EF),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.location_on_rounded,
                color: novaGreen,
                size: 20,
              ),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 7,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        _recipient,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: novaInk,
                        ),
                      ),
                      Text(
                        _phone,
                        style: const TextStyle(fontSize: 12, color: novaMuted),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE4F8EF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'UTAMA',
                          style: TextStyle(
                            color: novaGreen,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _address,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: Color(0xFF3D4A42),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _orderCard() => _checkoutCard(
    child: Column(
      children: [
        Row(
          children: [
            const Icon(Icons.shopping_bag_outlined, color: novaGreen, size: 20),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Ringkasan Pesanan',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: novaInk,
                ),
              ),
            ),
            Text(
              '${widget.quantity} Produk',
              style: const TextStyle(fontSize: 11, color: novaMuted),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Divider(height: 1, color: Color(0xFFE5EEFF)),
        ),
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(11),
              child: Image.network(
                widget.product.image,
                width: 78,
                height: 78,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 78,
                  height: 78,
                  color: const Color(0xFFEAF0F4),
                  child: const Icon(
                    Icons.image_not_supported_outlined,
                    color: novaMuted,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: novaInk,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '$_selectedVariant',
                    style: const TextStyle(fontSize: 11, color: novaMuted),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          formatPrice(widget.product.price),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: novaInk,
                          ),
                        ),
                      ),
                      Text(
                        'x${widget.quantity}',
                        style: const TextStyle(fontSize: 11, color: novaMuted),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 9),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFE4F8EF),
              borderRadius: BorderRadius.circular(7),
            ),
            child: const Text(
              'Stok Tersedia',
              style: TextStyle(
                fontSize: 10,
                color: novaGreen,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    ),
  );

  String get _selectedVariant => '${widget.color} / ${widget.size}';

  Widget _shippingAndNoteCard() => _checkoutCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.schedule_rounded, color: novaMuted, size: 19),
            const SizedBox(width: 7),
            const Expanded(
              child: Text(
                'Pengiriman Reguler',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: novaInk,
                ),
              ),
            ),
            Text(
              formatPrice(_shippingCost),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: novaInk,
              ),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(left: 26, top: 4, bottom: 12),
          child: Text(
            'Estimasi standar (2–3 hari kerja)',
            style: TextStyle(fontSize: 11, color: novaMuted),
          ),
        ),
        const Divider(height: 1, color: Color(0xFFE5EEFF)),
        const SizedBox(height: 12),
        const Text(
          'Catatan untuk Penjual (opsional)',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Color(0xFF3D4A42),
          ),
        ),
        const SizedBox(height: 7),
        TextField(
          controller: _noteController,
          maxLines: 2,
          minLines: 1,
          decoration: InputDecoration(
            hintText: 'Tambahkan catatan pesanan...',
            suffixIcon: const Icon(Icons.edit_note_rounded, color: novaMuted),
            filled: true,
            fillColor: novaSurface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(11),
              borderSide: const BorderSide(color: novaLine),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(11),
              borderSide: const BorderSide(color: novaLine),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(11),
              borderSide: const BorderSide(color: novaGreen),
            ),
          ),
        ),
      ],
    ),
  );

  Widget _paymentCard() => _checkoutCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.payments_outlined, color: novaGreen, size: 21),
            SizedBox(width: 8),
            Text(
              'Metode Pembayaran',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: novaInk,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _paymentOption(
          'Cash on Delivery (COD)',
          'Bayar tunai saat pesanan diterima',
          Icons.payments_outlined,
        ),
        const SizedBox(height: 8),
        _paymentOption(
          'Transfer Bank Manual',
          'Transfer sesuai instruksi pembayaran',
          Icons.account_balance_rounded,
          recommended: true,
        ),
        if (_paymentMethod == 'Transfer Bank Manual')
          Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: const Color(0xFFF3FAF6),
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: const Color(0xFFB7E8D1)),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline_rounded, color: novaGreen, size: 18),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Instruksi rekening dan konfirmasi pembayaran tersedia setelah pesanan dibuat.',
                    style: TextStyle(
                      fontSize: 11,
                      height: 1.4,
                      color: Color(0xFF3D4A42),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    ),
  );

  Widget _paymentOption(
    String title,
    String subtitle,
    IconData icon, {
    bool recommended = false,
  }) {
    final selected = _paymentMethod == title;
    return InkWell(
      onTap: () => setState(() => _paymentMethod = title),
      borderRadius: BorderRadius.circular(11),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF3FAF6) : Colors.white,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(
            color: selected ? novaGreen : novaLine,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFFE4F8EF)
                    : const Color(0xFFEFF4FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: selected ? novaGreen : novaInk, size: 21),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 6,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: novaInk,
                        ),
                      ),
                      if (recommended)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: novaGreen,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Rekomendasi',
                            style: TextStyle(
                              fontSize: 8,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 10, color: novaMuted),
                  ),
                ],
              ),
            ),
            Radio<String>(
              value: title,
              groupValue: _paymentMethod,
              activeColor: novaGreen,
              onChanged: (value) {
                if (value != null) setState(() => _paymentMethod = value);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _paymentSummaryCard() => _checkoutCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.receipt_long_rounded, color: novaGreen, size: 20),
            SizedBox(width: 8),
            Text(
              'Rincian Pembayaran',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: novaInk,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _priceRow('Subtotal Produk', _subtotal),
        const SizedBox(height: 10),
        _priceRow('Ongkos Kirim', _shippingCost),
        const SizedBox(height: 10),
        const Row(
          children: [
            Expanded(
              child: Text(
                'Diskon',
                style: TextStyle(fontSize: 12, color: novaMuted),
              ),
            ),
            Text(
              'Rp0',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: novaGreen,
              ),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Divider(height: 1, color: Color(0xFFE5EEFF)),
        ),
        Row(
          children: [
            const Expanded(
              child: Text(
                'Total Tagihan',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: novaInk,
                ),
              ),
            ),
            Text(
              formatPrice(_total),
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w800,
                color: novaGreen,
              ),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _priceRow(String label, int amount) => Row(
    children: [
      Expanded(
        child: Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF3D4A42)),
        ),
      ),
      Text(
        formatPrice(amount),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: novaInk,
        ),
      ),
    ],
  );

  Widget _checkoutBar() => Container(
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
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'TOTAL PEMBAYARAN',
                    style: TextStyle(
                      color: novaMuted,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: .7,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    formatPrice(_total),
                    style: const TextStyle(
                      color: novaInk,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            FilledButton.icon(
              onPressed: _placeOrder,
              iconAlignment: IconAlignment.end,
              icon: const Icon(Icons.arrow_forward_rounded, size: 17),
              label: const Text('Buat Pesanan'),
              style: FilledButton.styleFrom(
                backgroundColor: novaGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 17,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
                textStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _checkoutCard({required Widget child}) => Container(
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: const Color(0xFFE3EAE8)),
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

  Future<void> _editAddress() async {
    final nameController = TextEditingController(text: _recipient);
    final phoneController = TextEditingController(text: _phone);
    final addressController = TextEditingController(text: _address);
    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Ubah Alamat'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nama penerima'),
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Nomor telepon'),
                keyboardType: TextInputType.phone,
              ),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Alamat lengkap'),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
    if (saved == true && mounted) {
      setState(() {
        _recipient = nameController.text;
        _phone = phoneController.text;
        _address = addressController.text;
      });
    }
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
  }

  void _placeOrder() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.check_circle_rounded, color: novaGreen, size: 48),
        title: const Text('Pesanan berhasil dibuat'),
        content: Text(
          'Pesanan ${widget.product.name} telah dibuat dengan metode $_paymentMethod. Detail pembayaran dan status pesanan dapat dilihat di menu Pesanan.',
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(backgroundColor: novaGreen),
            child: const Text('Selesai'),
          ),
        ],
      ),
    );
  }
}

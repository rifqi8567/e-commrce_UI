import 'package:flutter/material.dart';
import '../../theme/nova_theme.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _name = 'Rifqi';
  String _email = 'rifqi@example.com';

  @override
  Widget build(BuildContext context) => SafeArea(
    bottom: false,
    child: CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white.withValues(alpha: .96),
          surfaceTintColor: Colors.transparent,
          toolbarHeight: 56,
          title: const Text('Profil Saya', style: TextStyle(color: novaInk, fontSize: 18, fontWeight: FontWeight.w800)),
          actions: [IconButton(tooltip: 'Pengaturan', onPressed: () => _message('Pengaturan akun'), icon: const Icon(Icons.settings_outlined, color: novaInk))],
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
          sliver: SliverList.list(children: [
            _profileCard(),
            const SizedBox(height: 14),
            _ordersCard(),
            const SizedBox(height: 14),
            _menuGroup([
              _MenuEntry(Icons.location_on_outlined, 'Alamat Saya', '1 Alamat Utama (Rumah)', () => _message('Alamat utama: Rumah')),
              _MenuEntry(Icons.receipt_long_outlined, 'Riwayat Pesanan', 'Semua transaksi yang telah selesai', () => _message('Riwayat pesanan')),
              _MenuEntry(Icons.favorite_border_rounded, 'Produk Favorit', 'Wishlist barang idamanmu', () => _message('12 produk favorit'), trailing: '12 Produk'),
            ]),
            const SizedBox(height: 14),
            _menuGroup([
              _MenuEntry(Icons.help_outline_rounded, 'Bantuan & Pusat Layanan', 'FAQ & Customer Care 24/7', () => _message('Pusat bantuan NOVA STORE')),
              _MenuEntry(Icons.privacy_tip_outlined, 'Kebijakan Privasi', 'Keamanan data akun dan privasi', () => _message('Kebijakan privasi')),
              _MenuEntry(Icons.info_outline_rounded, 'Tentang NOVA STORE', 'Modern Minimalist Retail', () => _message('NOVA STORE · v1.0.4'), trailing: 'v1.0.4'),
            ]),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () => showDialog<void>(context: context, builder: (context) => AlertDialog(
                icon: const Icon(Icons.logout_rounded, color: Colors.red),
                title: const Text('Keluar dari akun?'),
                content: const Text('Kamu dapat masuk kembali kapan saja.'),
                actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')), FilledButton(onPressed: () { Navigator.pop(context); _message('Kamu telah keluar'); }, child: const Text('Keluar'))],
              )),
              icon: const Icon(Icons.logout_rounded), label: const Text('Keluar dari Akun'),
              style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFFBA1A1A), backgroundColor: const Color(0xFFFFF5F4), side: const BorderSide(color: Color(0x33BA1A1A)), padding: const EdgeInsets.symmetric(vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), textStyle: const TextStyle(fontWeight: FontWeight.w800)),
            ),
          ]),
        ),
      ],
    ),
  );

  Widget _profileCard() => Container(
    padding: const EdgeInsets.all(16),
    decoration: _cardDecoration(),
    child: Column(children: [
      Row(children: [
        Stack(clipBehavior: Clip.none, children: [
          CircleAvatar(radius: 28, backgroundColor: const Color(0xFFE5EEFF), child: Text(_name.isEmpty ? 'R' : _name[0].toUpperCase(), style: const TextStyle(color: novaGreen, fontSize: 22, fontWeight: FontWeight.w800))),
          Positioned(right: -2, bottom: -1, child: Container(padding: const EdgeInsets.all(2), decoration: const BoxDecoration(color: novaGreen, shape: BoxShape.circle, border: Border.fromBorderSide(BorderSide(color: Colors.white, width: 2))), child: const Icon(Icons.verified_rounded, size: 13, color: Colors.white))),
        ]),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Wrap(spacing: 7, crossAxisAlignment: WrapCrossAlignment.center, children: [Text(_name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: novaInk)), Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: const Color(0xFFFFF7E8), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFFFE2A8))), child: const Text('★  Member Gold', style: TextStyle(color: Color(0xFF8A5A00), fontSize: 10, fontWeight: FontWeight.w700)))]),
          const SizedBox(height: 3), Text(_email, style: const TextStyle(color: novaMuted, fontSize: 12)),
        ])),
        OutlinedButton.icon(onPressed: _editProfile, icon: const Icon(Icons.edit_outlined, size: 14), label: const Text('Ubah'), style: OutlinedButton.styleFrom(foregroundColor: novaMuted, padding: const EdgeInsets.symmetric(horizontal: 9), visualDensity: VisualDensity.compact, side: const BorderSide(color: novaLine))),
      ]),
      const Padding(padding: EdgeInsets.symmetric(vertical: 14), child: Divider(height: 1, color: Color(0xFFEFF2F3))),
      Row(children: [const Icon(Icons.stars_rounded, color: novaGreen, size: 20), const SizedBox(width: 7), const Text('Nova Poin: ', style: TextStyle(color: novaMuted, fontSize: 12)), const Text('2.450 Poin', style: TextStyle(color: novaInk, fontSize: 12, fontWeight: FontWeight.w800)), const Spacer(), TextButton(onPressed: () => _message('Tukar poin Nova'), child: const Text('Tukar Poin  ›', style: TextStyle(color: novaGreen, fontSize: 11, fontWeight: FontWeight.w800))) ]),
    ]),
  );

  Widget _ordersCard() => Container(
    padding: const EdgeInsets.all(15), decoration: _cardDecoration(),
    child: Column(children: [Row(children: [const Expanded(child: Text('Pesanan Saya', style: TextStyle(color: novaInk, fontSize: 14, fontWeight: FontWeight.w800))), TextButton(onPressed: () => _message('Riwayat pesanan'), child: const Text('Lihat Riwayat  ›', style: TextStyle(color: novaMuted, fontSize: 11)))]), const SizedBox(height: 4), Row(children: [
      _OrderShortcut(Icons.account_balance_wallet_outlined, 'Belum Bayar', '1'), _OrderShortcut(Icons.inventory_2_outlined, 'Diproses'), _OrderShortcut(Icons.local_shipping_outlined, 'Dikirim', '1'), _OrderShortcut(Icons.check_circle_outline_rounded, 'Selesai'),
    ])]),
  );

  Widget _menuGroup(List<_MenuEntry> entries) => Container(
    decoration: _cardDecoration(), clipBehavior: Clip.antiAlias,
    child: Column(children: [for (var i = 0; i < entries.length; i++) ...[
      InkWell(onTap: entries[i].onTap, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12), child: Row(children: [Container(width: 37, height: 37, decoration: BoxDecoration(color: const Color(0xFFEAF5EF), borderRadius: BorderRadius.circular(10)), child: Icon(entries[i].icon, color: novaGreen, size: 20)), const SizedBox(width: 11), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(entries[i].title, style: const TextStyle(color: novaInk, fontSize: 12, fontWeight: FontWeight.w800)), const SizedBox(height: 3), Text(entries[i].subtitle, style: const TextStyle(color: novaMuted, fontSize: 10))])), if (entries[i].trailing != null) Padding(padding: const EdgeInsets.only(right: 5), child: Text(entries[i].trailing!, style: const TextStyle(color: novaMuted, fontSize: 10))), const Icon(Icons.chevron_right_rounded, color: Color(0xFF89948D), size: 19)]))),
      if (i != entries.length - 1) const Divider(height: 1, indent: 61, color: Color(0xFFEFF2F3)),
    ]]),
  );

  Future<void> _editProfile() async {
    final name = TextEditingController(text: _name);
    final email = TextEditingController(text: _email);
    final saved = await showDialog<bool>(context: context, builder: (context) => AlertDialog(title: const Text('Ubah Profil'), content: Column(mainAxisSize: MainAxisSize.min, children: [TextField(controller: name, decoration: const InputDecoration(labelText: 'Nama')), TextField(controller: email, decoration: const InputDecoration(labelText: 'Email'), keyboardType: TextInputType.emailAddress)]), actions: [TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')), FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Simpan'))]));
    if (saved == true && mounted) setState(() { _name = name.text.trim().isEmpty ? _name : name.text.trim(); _email = email.text.trim().isEmpty ? _email : email.text.trim(); });
    name.dispose(); email.dispose();
  }

  void _message(String message) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), behavior: SnackBarBehavior.floating, duration: const Duration(seconds: 1)));
}

class _MenuEntry {
  const _MenuEntry(this.icon, this.title, this.subtitle, this.onTap, {this.trailing});
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final String? trailing;
}

class _OrderShortcut extends StatelessWidget {
  const _OrderShortcut(this.icon, this.label, [this.count]);
  final IconData icon;
  final String label;
  final String? count;
  @override
  Widget build(BuildContext context) => Expanded(child: InkWell(onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(label), duration: const Duration(seconds: 1))), child: Column(children: [Stack(clipBehavior: Clip.none, children: [Container(width: 46, height: 46, decoration: BoxDecoration(color: const Color(0xFFF7F9FC), borderRadius: BorderRadius.circular(13), border: Border.all(color: const Color(0xFFE9EEF3))), child: Icon(icon, color: novaGreen, size: 23)), if (count != null) Positioned(right: -5, top: -5, child: Container(width: 17, height: 17, alignment: Alignment.center, decoration: const BoxDecoration(color: novaGreen, shape: BoxShape.circle), child: Text(count!, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800))))]), const SizedBox(height: 7), Text(label, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: novaMuted))])));
}

BoxDecoration _cardDecoration() => BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(17), border: Border.all(color: const Color(0xFFE3EAE8)), boxShadow: const [BoxShadow(color: Color(0x080B1C30), blurRadius: 8, offset: Offset(0, 2))]);


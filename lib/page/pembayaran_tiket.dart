import 'package:flutter/material.dart';
import 'package:ticket_app/page/bukti.dart';
import 'package:ticket_app/services/firebase.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PembayaranTiket extends StatefulWidget {
  final String idTiket;
  const PembayaranTiket({super.key, required this.idTiket});

  @override
  State<PembayaranTiket> createState() => _PembayaranTiketState();
}

class _PembayaranTiketState extends State<PembayaranTiket> {
  final FirestoreService service = FirestoreService();

  String _formatTanggal(dynamic tanggal) {
    if (tanggal is Timestamp) {
      final date = tanggal.toDate();
      return DateFormat('dd MMMM yyyy', 'id_ID').format(date);
    }
    return tanggal.toString();
  }

  String formatRupiah(dynamic amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  void _showMetodePembayaranModal(
    BuildContext context,
    String metode,
    String deskripsi,
    String imagePath,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.close, size: 24),
                  ),
                ),
                const SizedBox(height: 10),
                Image.asset(imagePath, height: 100),
                const SizedBox(height: 20),
                if (metode == "Kartu Kredit")
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "8810 7766 1234 9876",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black, fontSize: 12),
                        ),
                        const SizedBox(width: 20),
                        Icon(Icons.copy, color: Colors.black, size: 16),
                      ],
                    ),
                  ),
                Text(
                  metode,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(deskripsi, textAlign: TextAlign.center),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await service.addPembelian(widget.idTiket, Timestamp.now());
                    Navigator.pop(context); // tutup dialog
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Bon(idTiket: widget.idTiket),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Konfirmasi Pembayaran",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Pembayaran",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: service.getTicketById(widget.idTiket),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Tiket tidak ditemukan'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 5),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.receipt_long,
                              color: Colors.blue,
                              size: 40,
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Total Tagihan",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                Text(
                                  formatRupiah(data['harga']),
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      const SizedBox(height: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Nama Pesanan",
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              Text(
                                "${data['nama_tiket']} - ${data['kategori']}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Tanggal",
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              Text(
                                _formatTanggal(data['tanggal']),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  "Pilih Metode Pembayaran",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _paymentCard(
                  title: "Tunai (Cash)",
                  icon: 'images/money.jpg',
                  onTap:
                      () => _showMetodePembayaranModal(
                        context,
                        "Tunai (Cash)",
                        "Jika pembayaran telah diterima, klik button konfirmasi pembayaran untuk menyelesaikan transaksi",
                        'images/money.jpg',
                      ),
                ),
                _paymentCard(
                  title: "Kartu Kredit",
                  icon: 'images/debit.png',
                  onTap:
                      () => _showMetodePembayaranModal(
                        context,

                        "Kartu Kredit",
                        "Pastikan nominal dan tujuan pembayaran sudah benar sebelum melanjutkan.",
                        'images/debit.png',
                      ),
                ),
                _paymentCard(
                  title: "QRIS / QR Pay",
                  icon: 'images/qris.png',
                  onTap:
                      () => _showMetodePembayaranModal(
                        context,
                        "QRIS / QR Pay",
                        "Gunakan aplikasi e-wallet atau mobile banking untuk scan QR di atas dan selesaikan pembayaran",
                        'images/qris.png',
                      ),
                ),
                const SizedBox(height: 32),
                const Text(
                  "Punya pertanyaan?",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    print("Hubungi Admin");
                  },
                  icon: const Icon(Icons.help_outline),
                  label: const Text("Hubungi Admin untuk bantuan pembayaran."),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue,
                    side: const BorderSide(color: Colors.blue),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _paymentCard({
    required String title,
    required String icon,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Image.asset(icon, width: 36, height: 36),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}

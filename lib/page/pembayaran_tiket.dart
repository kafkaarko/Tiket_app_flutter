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
      return DateFormat('dd-MM-yyyy').format(date);
    }
    return tanggal.toString();
  }

  void _showMetodePembayaranModal(
      BuildContext context, String metode, String deskripsi, String imagePath) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(child: Image.asset(imagePath, height: 100)),
              const SizedBox(height: 20),
              Text(
                metode,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(deskripsi, textAlign: TextAlign.center),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Bon(idTiket: widget.idTiket)));
                },
                child: const Text("Lanjutkan Pembayaran"),
              ),
            ],
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
          "Pembayaran Tiket",
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
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.money, color: Colors.blue, size: 60),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Total Tagihan"),
                                  Text(
                                    "Rp. ${data['harga']}",
                                    style: const TextStyle(
                                        fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Divider(),
                          const SizedBox(height: 8),
                          Text("Nama Pesanan : ${data['nama_tiket']}"),
                          Text("Tanggal : ${_formatTanggal(data['tanggal'])}",
                              style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Pilih Metode Pembayaran",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          _buildPaymentOption(
                            title: "Tunai Cash",
                            onTap: () => _showMetodePembayaranModal(
                              context,
                              "Tunai Cash",
                              "Bayar secara langsung menggunakan uang tunai di tempat.",
                              'images/money.jpg',
                            ),
                          ),
                          const Divider(),
                          _buildPaymentOption(
                            title: "Kartu Kredit",
                            onTap: () => _showMetodePembayaranModal(
                              context,
                              "Kartu Kredit",
                              "Gunakan kartu kredit Anda untuk menyelesaikan pembayaran.",
                              'images/debit.png',
                            ),
                          ),
                          const Divider(),
                          _buildPaymentOption(
                            title: "Qriss",
                            onTap: () => _showMetodePembayaranModal(
                              context,
                              "Qriss",
                              "Pindai kode QR menggunakan aplikasi e-wallet Anda.",
                              'images/qris.png',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    "Punya pertanyaan?",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      print("Hubungi CS");
                    },
                    child: const Text("Hubungi CS", style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPaymentOption({required String title, required VoidCallback onTap}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: const TextStyle(color: Colors.blue)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.blue),
      onTap: onTap,
    );
  }
}

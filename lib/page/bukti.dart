import 'package:flutter/material.dart';
import 'package:ticket_app/page/list_tiket.dart';
import 'package:ticket_app/services/firebase.dart';

class Bon extends StatefulWidget {
  final String idTiket;
  const Bon({super.key, required this.idTiket});

  @override
  State<Bon> createState() => _BonState();
}

class _BonState extends State<Bon> {
  final FirestoreService service = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Bukti Pembayaran",
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
            child: Column(
              children: [
                Card(
                  margin: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.check_circle_outline,
                          color: Colors.green,
                          size: 70,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "Transaksi kamu telah berhasil!",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          "Detail pembelian ada di bawah ini.",
                          style: TextStyle(fontSize: 14),
                        ),
                        const Divider(height: 30, thickness: 1.2),

                        /// Nama Tiket dan Harga sejajar
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Nama Tiket:",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[700],
                              ),
                            ),
                            Text(
                              "${data['nama_tiket']}",
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        /// Kategori
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Kategori:",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[700],
                              ),
                            ),
                            Text(
                              "${data['kategori']}",
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        /// Harga Tiket
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Harga Tiket:",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[700],
                              ),
                            ),
                            Text(
                              "Rp. ${data['harga']}",
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        /// Total dengan icon uang
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.attach_money, color: Colors.blue),
                                SizedBox(width: 6),
                                Text(
                                  "Total Pembayaran:",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "Rp. ${data['harga']}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// Tombol Aksi
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ListTicket(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.arrow_back),
                          label: const Text("Kembali"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  "Bukti berhasil didownload",
                                ),
                                backgroundColor: Colors.green,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                            // fitur unduh nanti bisa ditambahkan
                          },
                          icon: const Icon(Icons.download),
                          label: const Text("Unduh Bukti"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }
}

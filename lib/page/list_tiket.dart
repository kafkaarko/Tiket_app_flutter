import 'package:flutter/material.dart';
import 'package:ticket_app/page/pembayaran_tiket.dart';
import 'package:ticket_app/services/firebase.dart';

class ListTicket extends StatefulWidget {
  final FirestoreService service = FirestoreService();
  ListTicket({super.key});

  @override
  State<ListTicket> createState() => _ListTicketState();
}

class _ListTicketState extends State<ListTicket> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Daftar Tiket",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder(
        stream: widget.service.getTickets(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "Tidak ada data tiket",
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    data['nama_tiket'] ?? 'Nama tiket tidak tersedia',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        data['kategori'] ?? 'Kategori tidak tersedia',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Rp. ${data['harga'] ?? 0}",
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      
                       mainAxisSize: MainAxisSize.min, // <== Tambahkan ini
                      children: [
                        const Icon(Icons.shopping_cart_checkout, color: Colors.white),
                     const Text(
                      "beli",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                      ],
                    ),
                  ),
                  onTap: () {
                    final docId = docs[index].id; 
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PembayaranTiket(idTiket: docId),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference ticket = FirebaseFirestore.instance.collection(
    'ticket',
  );
  final CollectionReference pembelian = FirebaseFirestore.instance.collection(
    'pembelian',
  );

  Stream<QuerySnapshot> getTickets() {
    return ticket.snapshots();
  }
  Stream<QuerySnapshot> getPembelian() {
    return pembelian.snapshots();
  }

  Future<void> addPembelian(String id_tiket, Timestamp waktu) {
  return pembelian.add({
    'id_tiket': id_tiket,
    'waktu': waktu,
    // 'timestamp': DateTime.now(),
  });
}
  Future<DocumentSnapshot> getTicketById(String id) {
    return ticket.doc(id).get();
  }

  Stream<List<Map<String, dynamic>>> getPembelianDenganTiket() async* {
  await for (var snapshot in pembelian.snapshots()) {
    List<Map<String, dynamic>> hasil = [];

     for (var doc in snapshot.docs) {

      final pembelianData = doc.data() as Map<String, dynamic>;

      final idTiket = pembelianData['id_tiket'];

        if (idTiket == null || idTiket is! String) {
        continue; // Skip dokumen yang tidak valid
      }

      final tiketSnapshot = await ticket.doc(idTiket).get();

        if (!tiketSnapshot.exists || tiketSnapshot.data() == null) {
        continue; // Skip kalau tiket tidak ditemukan
      }

      final tiketData = tiketSnapshot.data() as Map<String, dynamic>;

      // Gabungkan semua data ke satu Map
      hasil.add({
        ...pembelianData, // data pembelian
        ...tiketData,     // data tiket
        'docId': doc.id,  // simpan juga ID dokumen pembelian
      });
    }



    yield hasil;
  }
}
}


import 'package:flutter/material.dart';
import 'package:ticket_app/page/list_tiket.dart';

class PageTiket extends StatelessWidget {
  const PageTiket({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(image: const AssetImage("images/cwe.jpg")),
            const Text(
              "Ticket APP",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Membantu anda untuk membeli Tiket dengan mudah dan efesien",
              style: TextStyle(
                fontSize: 13,
                wordSpacing: 0.5,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity, // tombol selebar parent (kolom)
              height: 50, // tinggi tombol
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  ListTicket()),
                  );
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue, // opsional: warna latar
                  foregroundColor: Colors.white, // warna teks
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text("Beli Tiket"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

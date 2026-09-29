import 'package:flutter/material.dart';

void main() {
  runApp(const UsakKeşifApp());
}

class UsakKeşifApp extends StatelessWidget {
  const UsakKeşifApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Uşak Keşif',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
        useMaterial3: true,
      ),
      home: const GirisEkrani(),
    );
  }
}

// --- VERİ MODELLERİ & MERKEZİ HAFIZA ---
class ProfilModel {
  String id;
  String isim;
  int yas;
  String semt;
  String bio;
  String resimUrl;

  ProfilModel({
    required this.id,
    required this.isim,
    required this.yas,
    required this.semt,
    required this.bio,
    required this.resimUrl,
  });
}

class SohbetMesaj {
  String gonderen;
  String icerik;
  SohbetMesaj({required this.gonderen, required this.icerik});
}

class UygulamaVeritabani {
  static String aktifKullaniciAdi = 'Oğuz';
  
  // Uşak'taki keşfedilmeyi bekleyen örnek profiller
  static List<ProfilModel> kesifProfilleri = [
    ProfilModel(id: '1', isim: 'Zeynep', yas: 24, semt: 'Atatürk Mah.', bio: 'Uşak merkezde yaşıyorum, kahve ve yürüyüş severim.', resimUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=500'),
    ProfilModel(id: '2', isim: 'Merve', yas: 23, semt: 'İsmetpaşa Cad.', bio: 'Üniversite öğrencisiyim, yeni insanlarla tanışmak harika olur.', resimUrl: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=500'),
    ProfilModel(id: '3', isim: 'Emre', yas: 26, semt: 'Fatih Mah.', bio: 'Kuryelik yapıyorum, motosiklet ve kamp tutkunuyum.', resimUrl: 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=500'),
  ];

  static List<ProfilModel> eslesmeler = [];
  static Map<String, List<SohbetMesaj>> sohbetler = {};
}

// --- 1. GİRİŞ EKRANI ---
class GirisEkrani extends StatefulWidget {
  const GirisEkrani({super.key});

  @override
  State<GirisEkrani> createState() => _GirisEkraniState();
}

class _GirisEkraniState extends State<GirisEkrani> {
  final adController = TextEditingController(text: UygulamaVeritabani.aktifKullaniciAdi);

  void girisYap() {
    if (adController.text.isNotEmpty) {
      UygulamaVeritabani.aktifKullaniciAdi = adController.text;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AnaPanel()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink.shade700, Colors.deepOrange.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              elevation: 12,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                call: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.local_fire_department, size: 72, color: Colors.pinkAccent),
                    const SizedBox(height: 12),
                    const Text('Uşak Keşif', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    const Text('Uşak\'ın yeni nesil buluşma noktası', style: TextStyle(color: Colors.grey), textAlign: TextAlign.center),
                    const SizedBox(height: 24),
                    TextField(
                      controller: adController,
                      decoration: const InputDecoration(
                        labelText: 'Adınız',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pinkAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: girisYap,
                        child: const Text('Keşfetmeye Başla', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// --- 2. ANA PANEL & SEKMELER ---
class AnaPanel extends StatefulWidget {
  const AnaPanel({super.key});

  @override
  State<AnaPanel> createState() => _AnaPanelState();
}

class _AnaPanelState extends State<AnaPanel> {
  int _seciliSekme = 0;

  final List<Widget> _sayfalar = [
    const KesifEkrani(),
    const EslenmelerEkrani(),
    const ProfilEkrani(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _sayfalar[_seciliSekme],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _seciliSekme,
        selectedItemColor: Colors.pinkAccent,
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _seciliSekme = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.local_fire_department), label: 'Keşfet'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble), label: 'Eşleşmeler'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profilim'),
        ],
      ),
    );
  }
}

// --- 3. KEŞİF EKRANI (TİNDER KARTLARI) ---
class KesifEkrani extends StatefulWidget {
  const KesifEkrani({super.key});

  @override
  State<KesifEkrani> createState() => _KesifEkraniState();
}

class _KesifEkraniState extends State<KesifEkrani> {
  int currentIndex = 0;

  void profilBegen(ProfilModel profil) {
    setState(() {
      UygulamaVeritabani.eslesmeler.add(profil);
      UygulamaVeritabani.sohbetler[profil.id] = [
        SohbetMesaj(gonderen: profil.isim, icerik: 'Selam! Uşak\'ta eşleştik 🎉')
      ];
    });

    // Eşleşme Bildirimi (Pop-up)
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eşleşme Oldu! 🎉', textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(radius: 40, backgroundImage: NetworkImage(profil.resimUrl)),
            const SizedBox(height: 12),
            Text('${profil.isim} ile eşleştiniz!', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            const Text('Hemen sohbet etmeye başlayabilirsin.'),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent, foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                if (UygulamaVeritabani.kesifProfilleri.isNotEmpty) {
                  UygulamaVeritabani.kesifProfilleri.removeAt(currentIndex);
                  if (currentIndex >= UygulamaVeritabani.kesifProfilleri.length) {
                    currentIndex = 0;
                  }
                }
              });
            },
            child: const Text('Harika'),
          ),
        ],
      ),
    );
  }

  void profilGec() {
    setState(() {
      if (UygulamaVeritabani.kesifProfilleri.isNotEmpty) {
        UygulamaVeritabani.kesifProfilleri.removeAt(currentIndex);
        if (currentIndex >= UygulamaVeritabani.kesifProfilleri.length) {
          currentIndex = 0;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool bitti = UygulamaVeritabani.kesifProfilleri.isEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Uşak Keşif', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.pinkAccent)),
        centerTitle: true,
      ),
      body: bitti
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Uşak\'ta başka profil kalmadı!', style: TextStyle(fontSize: 18, color: Colors.grey)),
                  Text('Daha sonra tekrar kontrol et.', style: TextStyle(color: Colors.black54)),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            UygulamaVeritabani.kesifProfilleri[currentIndex].resimUrl,
                            fit: BoxFit.cover,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 20,
                            left: 20,
                            right: 20,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${UygulamaVeritabani.kesifProfilleri[currentIndex].isim}, ${UygulamaVeritabani.kesifProfilleri[currentIndex].yas}',
                                  style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on, color: Colors.pinkAccent, size: 18),
                                    const SizedBox(width: 4),
                                    Text(UygulamaVeritabani.kesifProfilleri[currentIndex].semt, style: const TextStyle(color: Colors.white70, fontSize: 16)),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  UygulamaVeritabani.kesifProfilleri[currentIndex].bio,
                                  style: const TextStyle(color: Colors.white, fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FloatingActionButton(
                        heroTag: 'red',
                        backgroundColor: Colors.white,
                        onPressed: profilGec,
                        child: const Icon(Icons.close, color: Colors.red, size: 32),
                      ),
                      FloatingActionButton(
                        heroTag: 'green',
                        backgroundColor: Colors.white,
                        onPressed: () => profilBegen(UygulamaVeritabani.kesifProfilleri[currentIndex]),
                        child: const Icon(Icons.favorite, color: Colors.pinkAccent, size: 32),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
    );
  }
}

// --- 4. EŞLEŞMELER & SOHBET LİSTESİ ---
class EslenmelerEkrani extends StatelessWidget {
  const EslenmelerEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Eşleşmeler & Sohbetler')),
      body: UygulamaVeritabani.eslesmeler.isEmpty
          ? const Center(child: Text('Henüz bir eşleşmen yok. Keşfetmeye başla!'))
          : ListView.builder(
              itemCount: UygulamaVeritabani.eslesmeler.length,
              itemBuilder: (context, index) {
                final profil = UygulamaVeritabani.eslesmeler[index];
                return ListTile(
                  leading: CircleAvatar(backgroundImage: NetworkImage(profil.resimUrl), radius: 28),
                  title: Text(profil.isim, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text('Sohbet başlatmak için dokun...'),
                  trailing: const Icon(Icons.chat, color: Colors.pinkAccent),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SohbetDetayEkrani(profil: profil)),
                    );
                  },
                );
              },
            ),
    );
  }
}

// --- 5. ÖZEL SOHBET EKRANI ---
class SohbetDetayEkrani extends StatefulWidget {
  final ProfilModel profil;
  const SohbetDetayEkrani({super.key, required this.profil});

  @override
  State<SohbetDetayEkrani> createState() => _SohbetDetayEkraniState();
}

class _SohbetDetayEkraniState extends State<SohbetDetayEkrani> {
  final mesajController = TextEditingController();

  void mesajGonder() {
    if (mesajController.text.isNotEmpty) {
      setState(() {
        UygulamaVeritabani.sohbetler[widget.profil.id]!.add(
          SohbetMesaj(gonderen: UygulamaVeritabani.aktifKullaniciAdi, icerik: mesajController.text),
        );
        mesajController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<SohbetMesaj> mesajlar = UygulamaVeritabani.sohbetler[widget.profil.id] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(backgroundImage: NetworkImage(widget.profil.resimUrl), radius: 16),
            const SizedBox(width: 10),
            Text(widget.profil.isim),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: mesajlar.length,
              itemBuilder: (context, index) {
                final m = mesajlar[index];
                bool bendenMi = m.gonderen == UygulamaVeritabani.aktifKullaniciAdi;
                return Align(
                  alignment: bendenMi ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: bendenMi ? Colors.pink.shade100 : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(m.icerik, style: const TextStyle(fontSize: 16)),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: mesajController,
                    decoration: const InputDecoration(hintText: 'Mesaj yaz...', border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.pinkAccent),
                  onPressed: mesajGonder,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- 6. PROFİLİM EKRANI ---
class ProfilEkrani extends StatelessWidget {
  const ProfilEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profilim')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage('https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=500'),
              ),
              const SizedBox(height: 16),
              Text(UygulamaVeritabani.aktifKullaniciAdi, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const Text('Uşak Merkez', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: const [
                      ListTile(leading: Icon(Icons.verified, color: Colors.pinkAccent), title: Text('Hesap Durumu'), trailing: Text('Aktif')),
                      Divider(),
                      ListTile(leading: Icon(Icons.location_city, color: Colors.pinkAccent), title: Text('Konum'), trailing: Text('Uşak')),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          brightness: Brightness.light,
          colorScheme: ColorScheme.fromSeed(
              seedColor: Color.fromARGB(255, 34, 51, 119))),
      home: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String nama = "", nim = "", prodi = "";
  double ipk = 0;
  final fieldNama = TextEditingController();
  final fieldNIM = TextEditingController();
  final fieldProdi = TextEditingController();
  final fieldIPK = TextEditingController();

  getStudentName(String nama) {
    this.nama = nama;
  }

  getStudentID(String nim) {
    this.nim = nim;
  }

  getStudyProgram(String prodi) {
    this.prodi = prodi;
  }

  getStudentIPK(String ipk) {
    this.ipk = double.parse(ipk);
  }

  createData() {
    final snackBar = SnackBar(
      content: Text('$nama berhasil ditambahkan'),
    );

    CollectionReference ref =
        FirebaseFirestore.instance.collection('Mahasiswa');

    Map<String, dynamic> mahasiswa = {
      "nama": nama,
      "nim": nim,
      "programStudi": prodi,
      "ipk": ipk
    };

    ref.doc(nama).set(mahasiswa).whenComplete(
        () => ScaffoldMessenger.of(context).showSnackBar(snackBar));
  }

  readData() {
    const snackBar = SnackBar(
      content: Text('Data tidak ditemukan'),
    );

    CollectionReference ref =
        FirebaseFirestore.instance.collection('Mahasiswa');

    ref.doc(nama).get().then((datasnapshot) {
      if (datasnapshot.exists) {
        fieldNama.text = datasnapshot["nama"];
        fieldNIM.text = datasnapshot["nim"];
        fieldProdi.text = datasnapshot["programStudi"];
        fieldIPK.text = datasnapshot["ipk"].toString();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        clearText();
      }
      ;
    });
  }

  updateData() {
    final snackBar = SnackBar(
      content: Text('$nama berhasil diupdate'),
    );

    CollectionReference ref =
        FirebaseFirestore.instance.collection('Mahasiswa');

    Map<String, dynamic> mahasiswa = {
      "nama": fieldNama.text,
      "nim": fieldNIM.text,
      "programStudi": fieldProdi.text,
      "ipk": double.parse(fieldIPK.text)
    };

    ref.doc(nama).set(mahasiswa).whenComplete(
        () => ScaffoldMessenger.of(context).showSnackBar(snackBar));
  }

  deleteData() {
    final snackBar = SnackBar(
      content: Text('$nama berhasil dihapus'),
    );

    CollectionReference ref =
        FirebaseFirestore.instance.collection('Mahasiswa');

    ref.doc(nama).delete().whenComplete(
        () => ScaffoldMessenger.of(context).showSnackBar(snackBar));
  }

  clearText() {
    fieldNama.clear();
    fieldNIM.clear();
    fieldProdi.clear();
    fieldIPK.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/ubm putih.png',
              fit: BoxFit.contain,
              height: 32,
            ),
            const SizedBox(width: 15),
            const Text("Kampusku UBM",
                style: TextStyle(color: Color.fromARGB(255, 255, 196, 19))),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: TextFormField(
                controller: fieldNama,
                decoration: const InputDecoration(
                    labelText: "Nama",
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 34, 51, 119),
                            width: 2.0))),
                onChanged: (String nama) {
                  getStudentName(nama);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: TextFormField(
                controller: fieldNIM,
                decoration: const InputDecoration(
                    labelText: "NIM",
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 34, 51, 119),
                            width: 2.0))),
                onChanged: (String nim) {
                  getStudentID(nim);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: TextFormField(
                controller: fieldProdi,
                decoration: const InputDecoration(
                    labelText: "Program Studi",
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 34, 51, 119),
                            width: 2.0))),
                onChanged: (String prodi) {
                  getStudyProgram(prodi);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: TextFormField(
                controller: fieldIPK,
                decoration: const InputDecoration(
                    labelText: "IPK",
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 34, 51, 119),
                            width: 2.0))),
                onChanged: (String ipk) {
                  getStudentIPK(ipk);
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      createData();
                      clearText();
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text("Create",
                        style: TextStyle(color: Colors.white))),
                ElevatedButton(
                    onPressed: () {
                      readData();
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    child: const Text("Read",
                        style: TextStyle(color: Colors.white))),
                ElevatedButton(
                    onPressed: () {
                      updateData();
                      clearText();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow[700]),
                    child: const Text("Update",
                        style: TextStyle(color: Colors.white))),
                ElevatedButton(
                    onPressed: () {
                      deleteData();
                      clearText();
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text("Delete",
                        style: TextStyle(color: Colors.white))),
              ],
            ),
            const Padding(
              padding: const EdgeInsets.fromLTRB(13.0, 30.0, 0, 10.0),
              child: Row(
                children: [
                  Expanded(
                      child: Text('Nama',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(
                      child: Text('NIM',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(
                      child: Text('Prodi',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(
                      child: Text('IPK',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(13.0, 0, 0, 30.0),
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Mahasiswa')
                      .snapshots(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (contest, index) {
                            DocumentSnapshot documentSnapshot =
                                snapshot.data!.docs[index];
                            return Row(
                              children: [
                                Expanded(child: Text(documentSnapshot["nama"])),
                                Expanded(child: Text(documentSnapshot["nim"])),
                                Expanded(
                                    child:
                                        Text(documentSnapshot["programStudi"])),
                                Expanded(
                                    child: Text(
                                        documentSnapshot["ipk"].toString())),
                              ],
                            );
                          });
                    } else {
                      return const Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}

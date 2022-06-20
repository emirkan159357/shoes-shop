// ignore_for_file: file_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'detail_page.dart';
import 'login_page.dart';
import 'main.dart';

class MainPage extends StatefulWidget {
  final User? user;

  const MainPage({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SizedBox(
        height: height,
        child: Expanded(
          child: ListView(
            shrinkWrap: true,
            children: [
              SizedBox(
                height: height * 0.8,
                child: StreamBuilder<QuerySnapshot>(
                    stream: firestore
                        .collection('ayakkabi')
                        // .where('isAdmin', isEqualTo: true)
                        .orderBy('time', descending: true)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return const Text("Ayakkabı yok.");
                      }
                      return ListView(
                        children: getExpenseItems(snapshot),
                      );
                    }),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      auth.signOut();
                      isLoginLoading = false;
                      isCreateLoading = false;
                    },
                    child: const Text('Çıkış Yap'),
                  ),
                  const SizedBox(width: 20),
                  OutlinedButton(
                    onPressed: () async {
                      firestore
                          .collection('users')
                          .doc(widget.user!.uid)
                          .delete();
                      firestore
                          .collection('users')
                          .doc(widget.user!.uid)
                          .collection('ayakkabi')
                          .doc()
                          .delete();
                      auth.currentUser?.delete();
                      isLoginLoading = false;
                      isCreateLoading = false;
                    },
                    child: const Text('Hesabı Sil'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    final width = MediaQuery.of(context).size.width;
    return snapshot.data!.docs
        .map(
          (doc) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => DetailPage(
                        aciklama: doc["aciklama"],
                        imageurl: doc["imageUrl"],
                        ayakkabifiyati: doc["ayakkabi-fiyati"],
                        ayakkabiadi: doc["ayakkabi-adi"],
                        time: doc["time"],
                      ),
                    ));
              },
              child: Container(
                width: width * 0.9,
                color: Colors.black26,
                child: ListTile(
                  leading: CachedNetworkImage(
                    imageUrl: doc['imageUrl'],
                    placeholder: (context, url) =>
                        const CupertinoActivityIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                  title: Text(doc["ayakkabi-adi"]),
                  subtitle: Text(doc["ayakkabi-fiyati"]),
                ),
              ),
            ),
          ),
        )
        .toList();
  }
}

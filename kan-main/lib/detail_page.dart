import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'basket.dart';
import 'home.dart';
import 'main.dart';

class DetailPage extends StatefulWidget {
  var aciklama;
  var imageurl;
  var ayakkabifiyati;
  var ayakkabiadi;
  var time;
  DetailPage({
    Key? key,
    required this.ayakkabiadi,
    required this.ayakkabifiyati,
    required this.aciklama,
    required this.imageurl,
    required this.time,
  }) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Center(
            child: Column(
          children: [
            SizedBox(height: width * 0.1),
            CachedNetworkImage(
              imageUrl: widget.imageurl,
              placeholder: (context, url) => const CupertinoActivityIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            const SizedBox(height: 20),
            Text(widget.ayakkabiadi),
            const SizedBox(height: 20),
            Text(widget.aciklama),
            const SizedBox(height: 20),
            Text(widget.ayakkabifiyati),
            const Spacer(),
            Container(
              width: width,
              height: 70,
              color: Colors.black12,
              child: Row(
                children: [
                  const SizedBox(width: 30),
                  SizedBox(
                    width: width * 0.4,
                    child: OutlinedButton(
                      onPressed: () async {
                        showCupertinoDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext ctx) {
                            return CupertinoAlertDialog(
                              content: SizedBox(
                                width: 200,
                                height: 200,
                                child: Center(
                                  child: Text(
                                    'Sepete Eklendi\n${widget.ayakkabifiyati}£',
                                    style: const TextStyle(fontSize: 30),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                        await firestore
                            .collection('basket')
                            .doc(user1!.uid)
                            .collection('ayakkabi')
                            .doc()
                            .set({
                          'ayakkabi-adi': widget.ayakkabiadi,
                          'ayakkabi-fiyati': widget.ayakkabifiyati,
                          'aciklama': widget.aciklama,
                          'uploaderUID': user1!.uid,
                          'imageUrl': widget.imageurl,
                          'time': DateTime.now(),
                        });
                        await Future.delayed(
                            const Duration(milliseconds: 1500));
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                      },
                      child: Text('${widget.ayakkabifiyati}£   Satın Al'),
                    ),
                  ),
                  const Spacer(),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => const Basket()));
                    },
                    child: const Text('Sepete Git'),
                  ),
                  const SizedBox(width: 30),
                ],
              ),
            )
          ],
        )),
      ),
    );
  }
}

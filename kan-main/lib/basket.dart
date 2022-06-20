import 'package:flutter/material.dart';

import 'home.dart';
import 'main.dart';

class Basket extends StatefulWidget {
  const Basket({Key? key}) : super(key: key);

  @override
  State<Basket> createState() => _BasketState();
}

class _BasketState extends State<Basket> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Text('Sepetim')),
      body: FutureBuilder(
        future: firestore
            .collection('basket')
            .doc(user1!.uid)
            .collection('ayakkabi')
            .orderBy('ayakkabi-fiyati')
            .get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: ((context, index) {
                return Container(
                  width: width * 0.9,
                  color: Colors.black26,
                  child: ListTile(
                    title: Text(snapshot.data.docs[index]["ayakkabi-adi"]),
                    subtitle: Text(snapshot.data.docs[index]["ayakkabi-fiyati"]),
                  ),
                );
              }),
            );
          } else {
            return const Text('Wait');
          }
        },
      ),
    );
  }
}

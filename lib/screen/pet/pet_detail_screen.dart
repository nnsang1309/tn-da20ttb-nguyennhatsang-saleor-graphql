import 'package:flutter/material.dart';

import '../../model/pet.dart';

class PetDetailScreen extends StatelessWidget {
  static const routeName = '/pet-detail';
  const PetDetailScreen(
    this.pet, {
    super.key,
  });

  final Pet pet;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chi tiet dong vat"),
      ),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          SizedBox(
            height: 300,
            width: double.infinity,
            child: Image.network(
              pet.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '\$${pet.title}',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 20,
            ),
          ),
          Text(
            '\$${pet.typePet}',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 20,
            ),
          ),
          Text(
            '\$${pet.price}',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 20,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            width: double.infinity,
            child: Text(
              pet.description,
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          ),
        ]),
      ),
    );
  }
}

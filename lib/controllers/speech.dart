import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class VisaCardWidget extends StatelessWidget {
  final String cardHolderName;
  final String cardNumber;
  final String expiryDate;

  const VisaCardWidget(
      {super.key,
      required this.cardHolderName,
      required this.cardNumber,
      required this.expiryDate});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.0,
      width: 320.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: const Color(0xFF273036),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  // width: 60.0,
                  // height: 60.0,
                  decoration: const BoxDecoration(
                      // image: DecorationImage(
                      //   image: AssetImage('assets/visa_logo.png'),
                      //   fit: BoxFit.contain,
                      // ),
                      ),
                ),
                const Text(
                  'CARD NUMBER',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Color(0xFFa6a7ac),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24.0),
            Text(
              cardNumber,
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'CARD HOLDER',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Color(0xFFa6a7ac),
                  ),
                ),
                Text(
                  'EXPIRES',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Color(0xFFa6a7ac),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  cardHolderName.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  expiryDate,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Speech extends StatelessWidget {
  final List<VisaCardWidget> _cards = [
    const VisaCardWidget(
      cardHolderName: 'John Doe',
      cardNumber: '**** **** **** 1234',
      expiryDate: '12/23',
    ),
    const VisaCardWidget(
      cardHolderName: 'Jane Doe',
      cardNumber: '**** **** **** 5678',
      expiryDate: '06/25',
    ),
    const VisaCardWidget(
      cardHolderName: 'Bob Smith',
      cardNumber: '**** **** **** 9012',
      expiryDate: '09/24',
    ),
  ];

  Speech({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Visa Card Carousel'),
      ),
      body: Column(
        children: [
          const Center(
            child: Text("MES CARTES"),
          ),
          CarouselSlider(
            options: CarouselOptions(
              // height: 300.0,
              viewportFraction: 0.9,
              enlargeCenterPage: false,
              aspectRatio: 16 / 9,
              enableInfiniteScroll: true,
              initialPage: 0,
              enlargeFactor: 0,
              padEnds: false,
              // autoPlay: true,
            ),
            items: _cards.map((card) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: card,
                  );
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

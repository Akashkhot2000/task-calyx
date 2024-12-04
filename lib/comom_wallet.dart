import 'package:flutter/material.dart';
import 'package:task/common_component.dart';

class WalletBalanceWidget extends StatelessWidget {
  const WalletBalanceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.27,
      width: MediaQuery.of(context).size.width * 1,
      decoration: BoxDecoration(
          color: Colors.blue, borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 28,
              child: Icon(Icons.flood),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text('Wallet Balance',
                style: TextStyle(fontSize: 15, color: Colors.white)),
            const SizedBox(
              height: 1,
            ),
            const Text('CAD 0.00',
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                    color: Colors.white)),
            const SizedBox(
              height: 6,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomButton(
                  buttonColor: Colors.white,
                  icon: const Icon(Icons.add),
                  text: 'Fund Wallet',
                  onPressed: () {},
                ),
                CustomButton(
                    buttonColor: Colors.blue,
                    text: 'Withdraw',
                    onPressed: () {},
                    textColor: Colors.white),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

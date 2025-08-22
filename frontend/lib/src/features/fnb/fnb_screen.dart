import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'fnb_viewmodel.dart';
import '../booking/booking_summary_screen.dart';

class FnbScreen extends StatelessWidget {
  static const routeName = '/fnb';
  const FnbScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<FnbViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('Food & Beverages')),
      body: ListView(
        children: [
          for (final i in vm.items)
            ListTile(
              title: Text(i.name),
              subtitle: Text('\$${i.price.toStringAsFixed(2)}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () => vm.dec(i)),
                  Text('${i.qty}'),
                  IconButton(
                      icon: const Icon(Icons.add), onPressed: () => vm.inc(i)),
                ],
              ),
            ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Text('Total: \$${vm.total.toStringAsFixed(2)}'),
              const Spacer(),
              ElevatedButton(
                onPressed: () =>
                    Navigator.pushNamed(context, BookingSummaryScreen.routeName),
                child: const Text('Continue'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

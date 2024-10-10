import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Check Internet Connection',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late bool isConnected;

  final Connectivity _connectivity = Connectivity();

  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  @override
  void initState() {
    super.initState();

    //ser nilai awal status koneksi internet
    isConnected = true;

    _initConnectivityStatus().then((_) {
      _connectivitySubscription =
          _connectivity.onConnectivityChanged.listen((result) {
        setState(() {
          isConnected = !result.contains(ConnectivityResult.none);
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();

    _connectivitySubscription.cancel();
  }

  //fungsi untuk mengecek koneksi internet
  Future<void> _initConnectivityStatus() async {
    final result = await _connectivity.checkConnectivity();
    setState(() {
      //perbarui status koneksi
      isConnected = !result.contains( ConnectivityResult.none);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 1000),
          child: Image.asset(
            isConnected ? 'assets/gambar1.jpg' : 'assets/gambar2.jpg',
            key: ValueKey<bool>(isConnected),
            width: 200,
            height: 200,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isConnected = !isConnected;
          });
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

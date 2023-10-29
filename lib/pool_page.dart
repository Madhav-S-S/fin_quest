import 'package:flutter/material.dart';

class PoolSelectionPage extends StatefulWidget {
  @override
  _PoolSelectionPageState createState() => _PoolSelectionPageState();
}

class _PoolSelectionPageState extends State<PoolSelectionPage> {
  final List<String> pools = ['100 Coins', '200 Coins', '500 Coins'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.red,
        title: Text('Select the Pool'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (final pool in pools)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent, // Set button color to transparent
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: Size(250, 170),
                    ),
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/m_coins.png',
                          width: 40,
                          height: 40,
                        ),
                        SizedBox(width: 10),
                        Text(
                          pool,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
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

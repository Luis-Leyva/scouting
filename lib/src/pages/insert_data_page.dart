import "package:flutter/material.dart";

class InsertDataPage extends StatelessWidget {
  const InsertDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(64.0),
          child: Column(
            children: [
              const SizedBox(
                height: 200,
                width: 200,
                child: Icon(Icons.data_object, size: 180),
              ),
              const TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(labelText: "Scouting Data"),
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 64),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Text(
                    'Submit Data',
                    style: TextStyle(fontSize: 24),
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

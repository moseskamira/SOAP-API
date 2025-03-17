import 'package:flutter/material.dart';

import '../services/soap_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SoapService soapService = SoapService();
  final TextEditingController tempController = TextEditingController();
  String? result = '';
  bool isCelsius = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SOAP Temperature Converter'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: tempController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: isCelsius ? "Enter Celsius" : "Enter Fahrenheit",
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    String temp = tempController.text;
                    if (temp.isNotEmpty) {
                      String? convertedTemp = await soapService
                          .convertCelsiusToFahrenheit(celsius: temp);
                      print('ENTERTHIS: ${convertedTemp}');

                      setState(() => result = convertedTemp);
                    }
                  },
                  child: Text("Celsius to Fahrenheit"),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () async {
                    String temp = tempController.text;
                    if (temp.isNotEmpty) {
                      String? convertedTemp =
                          await soapService.convertFahrenheitToCelsius(temp);
                      setState(() => result = convertedTemp);
                    }
                  },
                  child: Text("Fahrenheit to Celsius"),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(result != null ? "Converted Temp: $result" : "Herer"),
          ],
        ),
      ),
    );
  }
}

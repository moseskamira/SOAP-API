import 'package:flutter/material.dart';

import '../service/soap_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SoapService soapService = SoapService();
  final TextEditingController tempController = TextEditingController();
  String? result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SOAP API CRUD"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: tempController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Enter Celsius"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                String temp = tempController.text;
                await soapService.saveTemperature(temp);
                setState(() {});
              },
              child: Text("Create (Save Temp)"),
            ),
            ElevatedButton(
              onPressed: () async {
                String temp = tempController.text;
                String? fahrenheit =
                    await soapService.convertCelsiusToFahrenheit(temp);
                setState(() {
                  result = fahrenheit;
                });
              },
              child: Text("Read (Convert to Fahrenheit)"),
            ),
            ElevatedButton(
              onPressed: () async {
                String oldTemp = tempController.text;
                String newTemp = (double.parse(oldTemp) + 1).toString();
                await soapService.updateTemperature(oldTemp, newTemp);
                tempController.text = newTemp;
                setState(() {});
              },
              child: Text("Update (Modify Temp)"),
            ),
            ElevatedButton(
              onPressed: () async {
                String temp = tempController.text;
                await soapService.deleteTemperature(temp);
                tempController.clear();
                setState(() {
                  result = null;
                });
              },
              child: Text("Delete (Remove Temp)"),
            ),
            SizedBox(height: 20),
            Text(result != null ? "Fahrenheit: $result" : ""),
          ],
        ),
      ),
    );
  }
}

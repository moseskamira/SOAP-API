import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

import '../queries/soap_queries.dart';

class SoapService {
  final String url = "https://www.w3schools.com/xml/tempconvert.asmx";

  Future<String?> convertCelsiusToFahrenheit({required String celsius}) async {
    final String soapAction =
        'https://www.w3schools.com/xml/CelsiusToFahrenheit';
    final String requestBody =
        SoapQueries.celsiusToFahrenheit(celsius: celsius);
    return _sendRequest(requestBody, soapAction);
  }

  Future<String?> fetchCelsiusToFahrenheit(String celsius) async {
    String requestBody = SoapQueries.celsiusToFahrenheit(celsius: celsius);
    final soapAction = 'https://www.w3schools.com/xml/CelsiusToFahrenheit';
    return _sendRequest(requestBody, soapAction);
  }

  Future<String?> convertFahrenheitToCelsius(String fahrenheit) async {
    String requestBody = SoapQueries.fahrenheitToCelsius(fahrenheit);
    final soapAction = 'http://www.w3schools.com/xml/FahrenheitToCelsius';
    return _sendRequest(requestBody, soapAction);
  }

  Future<String?> _sendRequest(String requestBody, String soapAction) async {
    String? value;
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'text/xml; charset=utf-8',
          'SOAPAction': soapAction,
        },
        body: requestBody,
      );

      if (response.statusCode == 200) {
        try {
          final document = xml.XmlDocument.parse(response.body);
          final result = document
              .findAllElements('CelsiusToFahrenheitResult',
                  namespace: 'https://www.w3schools.com/xml/')
              .single
              .text;
          value = result;
        } catch (e) {
          print('Error while parsing response: $e');
        }
      } else {
        print('Failed request with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
    return value;
  }
}

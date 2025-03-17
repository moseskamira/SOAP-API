import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

import '../queries/soap_queries.dart';
import '../soap_constants/soap_constants.dart';

class SoapService {
  Future<String?> convertCelsiusToFahrenheit(String celsius) async {
    final requestBody = SoapQueries.celsiusToFahrenheit(celsius: celsius);
    return _sendRequest(requestBody, SoapConstants.celsiusToFahrenheitAction,
        SoapConstants.c2FResultTag);
  }

  Future<String?> convertFahrenheitToCelsius(String fahrenheit) async {
    final requestBody = SoapQueries.fahrenheitToCelsius(fahrenheit);
    return _sendRequest(requestBody, SoapConstants.fahrenheitToCelsiusAction,
        SoapConstants.f2CResultTag);
  }

  Future<String?> _sendRequest(
      String requestBody, String soapAction, String resultTag) async {
    try {
      final response = await http.post(
        Uri.parse(
          SoapConstants.baseUrl,
        ),
        headers: {
          'Content-Type': 'text/xml; charset=utf-8',
          'SOAPAction': soapAction,
        },
        body: requestBody,
      );

      if (response.statusCode == 200) {
        return _parseSoapResponse(response.body, resultTag);
      } else {
        print(
            'Request failed with status: ${response.statusCode} | Response: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error while making SOAP request: $e');
      return null;
    }
  }

  String? _parseSoapResponse(String responseBody, String resultTag) {
    try {
      final document = xml.XmlDocument.parse(responseBody);
      final resultElement = document.findAllElements(resultTag).singleOrNull;
      if (resultElement != null) {
        return resultElement.innerText;
      } else {
        print('SOAP response does not contain <$resultTag>');
        return null;
      }
    } catch (e) {
      print('Error parsing SOAP response: $e');
      return null;
    }
  }
}

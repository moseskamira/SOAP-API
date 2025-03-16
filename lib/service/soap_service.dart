import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

class SoapService {
  final String soapUrl = "https://www.w3schools.com/xml/tempconvert.asmx";

  Future<void> saveTemperature(String temp) async {
    print("Saved temperature: $temp");
  }

  Future<String?> convertCelsiusToFahrenheit(String celsius) async {
    final String soapRequest = '''
      <?xml version="1.0" encoding="utf-8"?>
      <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
                     xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
                     xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
        <soap:Body>
          <CelsiusToFahrenheit xmlns="https://www.w3schools.com/xml/">
            <Celsius>$celsius</Celsius>
          </CelsiusToFahrenheit>
        </soap:Body>
      </soap:Envelope>
    ''';

    try {
      final response = await http.post(
        Uri.parse(soapUrl),
        headers: {
          'Content-Type': 'text/xml; charset=utf-8',
          'SOAPAction': 'https://www.w3schools.com/xml/CelsiusToFahrenheit',
        },
        body: soapRequest,
      );

      if (response.statusCode == 200) {
        final result =
            parseSoapResponse(response.body, 'CelsiusToFahrenheitResult');
        return result;
      } else {
        print("Error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  Future<void> updateTemperature(String oldTemp, String newTemp) async {
    print("Updated temperature from $oldTemp to $newTemp");
  }

  Future<void> deleteTemperature(String temp) async {
    print("Deleted temperature: $temp");
  }

  String? parseSoapResponse(String responseBody, String elementName) {
    final document = xml.XmlDocument.parse(responseBody);
    final responseElement = document.findAllElements(elementName).first;
    return responseElement.text;
  }
}

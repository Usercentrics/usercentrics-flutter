import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:usercentrics_sdk/src/internal/internal.dart';
import 'package:usercentrics_sdk/src/model/model.dart';

void main() {
  // Data from the debugger
  const mockResponse = {
    "shouldCollectConsent": true,
    "consents": [
      {
        "templateId": "SJKM9Ns_ibQ",
        "status": true,
        "type": "EXPLICIT",
        "version": "10.4.5",
        "dataProcessor": "Facebook Connect",
        "isEssential": true,
        "history": [
          {
            "status": true,
            "timestampInMillis": 123,
            "type": "EXPLICIT",
          }
        ]
      },
    ],
    "geolocationRuleset": {
      "activeSettingsId": "settingsId",
      "bannerRequiredAtLocation": true
    },
    "location": {
      "countryCode": "PT",
      "regionCode": "PT11",
      "isInEU": true,
      "isInUS": false,
      "isInCalifornia": false
    }
  };

  const expectedResult = UsercentricsReadyStatus(
      shouldCollectConsent: true,
      consents: [
        UsercentricsServiceConsent(
          templateId: "SJKM9Ns_ibQ",
          status: true,
          dataProcessor: "Facebook Connect",
          version: "10.4.5",
          type: UsercentricsConsentType.explicit,
          isEssential: true,
          history: [
            UsercentricsConsentHistoryEntry(
              status: true,
              timestampInMillis: 123,
              type: UsercentricsConsentType.explicit,
            )
          ],
        ),
      ],
      geolocationRuleset: GeolocationRuleset(
          activeSettingsId: "settingsId", bannerRequiredAtLocation: true),
      location: UsercentricsLocation(
          countryCode: "PT",
          regionCode: "PT11",
          isInEU: true,
          isInUS: false,
          isInCalifornia: false));

  const MethodChannel channel = MethodChannel('usercentrics');
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('invoke', () async {
    int callCounter = 0;
    MethodCall? receivedCall;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      callCounter++;
      receivedCall = methodCall;
      return mockResponse;
    });
    const instance = MethodChannelClearUserSession();

    final result = await instance.invoke(channel: channel);

    expect(callCounter, 1);
    expect(receivedCall?.method, 'clearUserSession');
    expect(result, expectedResult);
  });
}

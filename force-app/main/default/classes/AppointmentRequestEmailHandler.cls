/**
 * Created by davin on 27/01/2022.
 */

global class AppointmentRequestEmailHandler implements Messaging.InboundEmailHandler {

	global Messaging.InboundEmailResult handleInboundEmail (Messaging.InboundEmail email,Messaging.InboundEnvelope envelop) {

		Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();

		try {

			Email_Handler_Config__mdt config = getCustomMetadata();

			System.assertNotEquals(null, config);
			System.assertNotEquals(null, config.Payload_ID__c);

			payloads__InboundPayload__c payload = [
				SELECT Id, Name, payloads__Integration__c, (
					SELECT Id, Name
					FROM payloads__Elements__r
				)
				FROM payloads__InboundPayload__c
				WHERE Id = :config.Payload_ID__c
			];

			Map<String, String> requestObj = new Map<String, String>();
System.debug('plain body');
			System.debug(email.plainTextBody);
			/*System.debug('rich body');
			System.debug(email.htmlBody);
			System.debug('headers: ' + email.headers);
			for (payloads__InboundPayloadElement__c elem : payload.payloads__Elements__r) {

				requestObj.put(elem.Name, '');
			}

			for (String str : email.plainTextBody.split('\n')) {

				for (String elemName : requestObj.keySet()) {

					if (str.startsWithIgnoreCase(elemName)) {

						String val = str.removeStartIgnoreCase(elemName).trim();
						requestObj.put(elemName, val);
					}
				}
			}*/

			Set<String> elementNames = new Set<String>();

			for (payloads__InboundPayloadElement__c elem : payload.payloads__Elements__r) {

				elementNames.add(elem.Name);
			}

			List<String> bodyParts = email.plainTextBody.split('\n');

			for (Integer i = 0; i < bodyParts.size(); i++) {

				String currentLine = bodyParts[i];

				for (payloads__InboundPayloadElement__c elem : payload.payloads__Elements__r) {

					if (currentLine.startsWith(elem.Name)) {

						if (currentLine.length() > elem.Name.length() && currentLine.containsWhitespace()) {

							String val = currentLine.removeStart(elem.Name).trim();
							requestObj.put(elem.Name, val);

						} else {

							if (bodyParts.size() > i) {

								String nextLine = bodyParts[i+1];

								if (!elementNames.contains(nextLine)) {

									requestObj.put(elem.Name, nextLine);
								}
							}
						}
					}
				}
			}
system.debug(JSON.serializePretty(requestObj));
			if (!String.isBlank(config.From_Element_Name__c) && elementNames.contains(config.From_Element_Name__c)) {

				requestObj.put(config.From_Element_Name__c, email.fromAddress);
			}

			if (!String.isBlank(config.Subject_Element_Name__c) && elementNames.contains(config.Subject_Element_Name__c)) {

				requestObj.put(config.Subject_Element_Name__c, email.subject);
			}

			insert new payloads__InboundPayloadJob__c(
				payloads__InboundPayload__c = payload.Id,
				payloads__ExecutionType__c = (config.Immediate__c)
					? 'Immediate'
					: 'Queueable',
				payloads__Request__c = JSON.serialize(requestObj),
				payloads__Integration__c = payload.payloads__Integration__c,
				payloads__Status__c = 'Ready'
			);

			result.success = true;

			return result;

		} catch (Exception ex) {

			result.success = false;
			result.message = 'Error processing request: ' + ex.getMessage();

			return result;
		}
	}

	private Email_Handler_Config__mdt getCustomMetadata () {

		if (!Test.isRunningTest()) {

			return [
				SELECT Id, DeveloperName, Payload_ID__c, Immediate__c, Subject_Element_Name__c, From_Element_Name__c
				FROM Email_Handler_Config__mdt
				WHERE DeveloperName = 'AppointmentRequestEmailHandler'
				LIMIT 1
			];

		} else {

			Email_Handler_Config__mdt config = new Email_Handler_Config__mdt();
			config.DeveloperName = 'AppointmentRequestEmailHandler';
			config.Payload_ID__c = [SELECT Id FROM payloads__InboundPayload__c LIMIT 1].Id;
			config.Immediate__c = true;
			config.Subject_Element_Name__c = 'subject';
			config.From_Element_Name__c = 'sender';

			return config;
		}
	}
}
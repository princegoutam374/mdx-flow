/**
 * Created by davin on 27/01/2022.
 */

@IsTest
public class AppointmentRequestEmailHandlerTest {

	@IsTest
	static void testInboundEmailMac () {

		Messaging.InboundEmail email = new Messaging.InboundEmail() ;
		Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();

		email.subject = 'Test Inbound Email';
		email.fromAddress = 'test@mdx.com';

		email.plainTextBody = '';
		email.plainTextBody += 'firstName Insight\n';
		email.plainTextBody += 'lastName Powered\n';

		new AppointmentRequestEmailHandler().handleInboundEmail(email, env);

		payloads__InboundPayloadJob__c job = [
			SELECT Id, payloads__Status__c, payloads__Request__c
			FROM payloads__InboundPayloadJob__c
		];

		System.assertEquals('Completed', job.payloads__Status__c);

		Map<String, String> reqMap = (Map<String, String>) JSON.deserialize(job.payloads__Request__c, Map<String, String>.class);
		System.assertEquals('test@mdx.com', reqMap.get('sender'));
		System.assertEquals('Test Inbound Email', reqMap.get('subject'));
		System.assertEquals('Insight', reqMap.get('firstName'));
		System.assertEquals('Powered', reqMap.get('lastName'));
	}

	@IsTest
	static void testInboundEmailWindows () {

		Messaging.InboundEmail email = new Messaging.InboundEmail() ;
		Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();

		email.subject = 'Test Inbound Email';
		email.fromAddress = 'test@mdx.com';

		email.plainTextBody = '';
		email.plainTextBody += 'firstName\nInsight\n';
		email.plainTextBody += 'lastName\nPowered\n';

		new AppointmentRequestEmailHandler().handleInboundEmail(email, env);

		payloads__InboundPayloadJob__c job = [
			SELECT Id, payloads__Status__c, payloads__Request__c
			FROM payloads__InboundPayloadJob__c
		];

		System.assertEquals('Completed', job.payloads__Status__c);

		Map<String, String> reqMap = (Map<String, String>) JSON.deserialize(job.payloads__Request__c, Map<String, String>.class);
		System.assertEquals('test@mdx.com', reqMap.get('sender'));
		System.assertEquals('Test Inbound Email', reqMap.get('subject'));
		System.assertEquals('Insight', reqMap.get('firstName'));
		System.assertEquals('Powered', reqMap.get('lastName'));
	}

	@TestSetup
	static void setupTestData () {

		payloads__Integration__c integration = new payloads__Integration__c(
			Name = 'Test Integration'
		);
		insert integration;

		payloads__InboundPayload__c payload = new payloads__InboundPayload__c(
			Name = 'Email Handler',
			payloads__Integration__c = integration.Id,
			payloads__ContentType__c = 'application/json'
		);
		insert payload;

		payloads__InboundPayloadElement__c firstNameElement = new payloads__InboundPayloadElement__c(
			payloads__InboundPayload__c = payload.Id,
			Name = 'firstName',
			payloads__Type__c = 'String'
		);
		insert firstNameElement;

		payloads__InboundPayloadElement__c lastNameElement = new payloads__InboundPayloadElement__c(
			payloads__InboundPayload__c = payload.Id,
			Name = 'lastName',
			payloads__Type__c = 'String'
		);
		insert lastNameElement;

		payloads__InboundPayloadElement__c subjectElement = new payloads__InboundPayloadElement__c(
			payloads__InboundPayload__c = payload.Id,
			Name = 'subject',
			payloads__Type__c = 'String'
		);
		insert subjectElement;

		payloads__InboundPayloadElement__c senderElement = new payloads__InboundPayloadElement__c(
			payloads__InboundPayload__c = payload.Id,
			Name = 'sender',
			payloads__Type__c = 'String'
		);
		insert senderElement;
	}
}
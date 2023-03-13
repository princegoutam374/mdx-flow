@isTest
public with sharing class FlowTest_InboundPayloadJob {
    @TestSetup
    static void makeData(){
        Account acc =  new Data.AccountBuilder()
        .newAccount()
        .newAccountPersonForTest()
        .setPersonmailingCountry('Canada')
        .setPersonMailingCity('New Brunswick')
        .setPersonMailingState('New Brunswick')
        .setPersonMailingStreet('New Brunswick')
        .setMailingStreet1('4206 Minnesota')
        .setMailingStreet2('Pine Apt. 165')
        .setConsentToText('Yes')
        .setFax('21212121')
        .setOfficeContactEmail('abc@test.com')
        .setOfficeContactName('Test Office Contact')
        .doInsert()
        .account;

        payloads__Integration__c integration = new payloads__Integration__c(
			Name = 'Test Integration'
		);
		insert integration;
    }

    /*
    * Type: Flow
    * Name: InboundPayloadJob (Record)
    * Scenario: Insert InboundPayloadJob record and set Payload Status to Failed, then failure email alert will be sent
    */
    @isTest
    static void testInboundPayloadJob(){
        payloads__Integration__c integration = [Select Id from payloads__Integration__c];
        Account acc = [Select Id from Account];
        payloads__InboundPayload__c payload = new payloads__InboundPayload__c(
			Name = 'Email Handler',
			payloads__Integration__c = integration.Id,
			payloads__ContentType__c = 'application/json'
		);
		insert payload;

        payloads__InboundPayloadJob__c inboundPayloadJob= new payloads__InboundPayloadJob__c(
				payloads__InboundPayload__c = payload.Id,
				payloads__Integration__c = payload.payloads__Integration__c,
				payloads__Status__c = 'Failed',
                Account__c = acc.Id
		);

        insert inboundPayloadJob;
    }
}
@isTest
public with sharing class FlowTest_OutboundJobFailure {
    @TestSetup
    static void createAccount(){
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
        
        sked__Region__c region = new Data.RegionBuilder()
        .newRegion()
        .setTimeZone('Australia/Brisbane')
        .doInsert()
        .region;

        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ZEPOSIA - GASTRO').getRecordTypeId();
        Case cs = new Data.CaseBuilder()
        .newCase()
        .setAccountId(acc.Id)
        .setRecordTypeId(recordTypeId)
        .setReferringProvider(acc.Id)
        .doInsert()
        .cs;

        payloads__Integration__c integration = new payloads__Integration__c(
			Name = 'Test Integration'
		);
		insert integration;

        payloads__OutboundPayload__c outBoundPayload = new payloads__OutboundPayload__c();
        outBoundPayload.payloads__Integration__c	 = integration.Id;
        insert outBoundPayload;

        payloads__OutboundPayloadJob__c  pay_load = new payloads__OutboundPayloadJob__c();
        pay_load.payloads__Integration__c  = integration.Id;
        pay_load.payloads__Status__c = 'New';
        pay_load.Case__c = cs.Id;
        pay_load.payloads__OutboundPayload__c  = outBoundPayload.Id;
        insert pay_load;
        
    }

    /*
    * Type: Flow
    * Name: Outbound Job (Failure) Record -V1
    * Node: Failure Alert
    * Scenario: Payload Job Status is changed and set to 'Failed', then email alert will be send out
    */
    @isTest
    static void testFailureAlert(){
        payloads__OutboundPayloadJob__c payloadJob = [Select Id, payloads__Status__c from payloads__OutboundPayloadJob__c limit 1];
        payloadJob.payloads__Status__c = 'Failed';
        update payloadJob;
    }
}
@isTest
public with sharing class FlowTest_MayzentCase {
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
        .setHCSPatientId('Test32434')
        .setPhone('3425643909')
        .doInsert()
        .account;

        sked__Region__c region = new Data.RegionBuilder()
        .newRegion()
        .setTimeZone('Australia/Brisbane')
        .doInsert()
        .region;
        
    }
    /*
    * Type: Flow
    * Name: Mayzent Case (Record)
    * Case: Case record type set to Mayzent, HCS Appoitment Type to First Dose Observation, then Appointment_Type__c will be FDO
    */
    @isTest
    static void testMayzentCase(){
        Account ac = [SELECT Id,HCS_Patient_Id__c FROM Account];

        payloads__Integration__c integration = new payloads__Integration__c(
			Name = 'Test Integration'
		);
		insert integration;

        payloads__OutboundPayload__c outBoundPayload = new payloads__OutboundPayload__c();
        outBoundPayload.payloads__Integration__c	 = integration.Id;
        insert outBoundPayload;
        
        sked__Region__c region = [Select Id from sked__Region__c];

        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('MAYZENT - BA').getRecordTypeId();
        Case cs = new Data.CaseBuilder()
        .newCase()
        .setAccountId(ac.Id)
        .setRecordTypeId(recordTypeId)
        .setReferringProvider(ac.Id)
        .setHCSAppointmentType('First Dose Observation')
        .doInsert()
        .cs;
        
        payloads__OutboundPayloadJob__c  pay_load = new payloads__OutboundPayloadJob__c();
        pay_load.payloads__Integration__c  = integration.Id;
        pay_load.payloads__Status__c = 'New';
        pay_load.Case__c = cs.Id;
        pay_load.payloads__OutboundPayload__c  = outBoundPayload.Id;
        insert pay_load;

        payloads__OutboundPayloadSource__c payloadSource = new payloads__OutboundPayloadSource__c();
        payloadSource.Name = 'Test Payload Source';
        payloadSource.payloads__OutboundPayload__c = outBoundPayload.Id;
        insert payloadSource;

        payloads__OutboundPayloadJobSource__c jobSource = new payloads__OutboundPayloadJobSource__c();
        jobSource.payloads__OutboundPayloadSource__c = payloadSource.Id;
        jobSource.payloads__Value__c = cs.Id;
        jobSource.payloads__OutboundPayloadJob__c = pay_load.Id;
        jobSource.payloads__OutboundPayload__c = outBoundPayload.Id;
        insert jobSource;

        Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body'); 
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test';
        cv.PathOnClient = 'test.pdf';
        cv.VersionData = bodyBlob;
        insert cv;

        ContentDistribution cd = new ContentDistribution();
        cd.Name = 'test';
        cd.ContentVersionId = cv.id;
        insert cd;

        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];

        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.LinkedEntityId = cs.Id;
        cdl.ContentDocumentId = documents[0].Id;
        insert cdl;
        Case res = [Select Id, Patient_ID_Plain_Text__c,HCS_Appointment_Type_Inbound__c,Appointment_Type__c from Case where Id =:cs.Id];
        System.assertEquals('FDO', res.Appointment_Type__c);
    }
    /*
    * Type: Flow
    * Name: Mayzent Case (Record)
    * Case: Case record type not set to Mayzent, then Appointment_Type__c will be not FDO
    */
    @isTest
    static void testMayzentCaseNegativeScenario(){
        Account ac = [SELECT Id,HCS_Patient_Id__c FROM Account];

        payloads__Integration__c integration = new payloads__Integration__c(
			Name = 'Test Integration'
		);
		insert integration;

        payloads__OutboundPayload__c outBoundPayload = new payloads__OutboundPayload__c();
        outBoundPayload.payloads__Integration__c	 = integration.Id;
        insert outBoundPayload;
        
        sked__Region__c region = [Select Id from sked__Region__c];

        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ZEPOSIA - GASTRO').getRecordTypeId();
        Case cs = new Data.CaseBuilder()
        .newCase()
        .setAccountId(ac.Id)
        .setRecordTypeId(recordTypeId)
        .setReferringProvider(ac.Id)
        .setHCSAppointmentType('First Dose Observation')
        .doInsert()
        .cs;
        
        payloads__OutboundPayloadJob__c  pay_load = new payloads__OutboundPayloadJob__c();
        pay_load.payloads__Integration__c  = integration.Id;
        pay_load.payloads__Status__c = 'New';
        pay_load.Case__c = cs.Id;
        pay_load.payloads__OutboundPayload__c  = outBoundPayload.Id;
        insert pay_load;

        payloads__OutboundPayloadSource__c payloadSource = new payloads__OutboundPayloadSource__c();
        payloadSource.Name = 'Test Payload Source';
        payloadSource.payloads__OutboundPayload__c = outBoundPayload.Id;
        insert payloadSource;

        payloads__OutboundPayloadJobSource__c jobSource = new payloads__OutboundPayloadJobSource__c();
        jobSource.payloads__OutboundPayloadSource__c = payloadSource.Id;
        jobSource.payloads__Value__c = cs.Id;
        jobSource.payloads__OutboundPayloadJob__c = pay_load.Id;
        jobSource.payloads__OutboundPayload__c = outBoundPayload.Id;
        insert jobSource;

        Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body'); 
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test';
        cv.PathOnClient = 'test.pdf';
        cv.VersionData = bodyBlob;
        insert cv;

        ContentDistribution cd = new ContentDistribution();
        cd.Name = 'test';
        cd.ContentVersionId = cv.id;
        insert cd;

        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];

        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.LinkedEntityId = cs.Id;
        cdl.ContentDocumentId = documents[0].Id;
        insert cdl;
        Case res = [Select Id, Patient_ID_Plain_Text__c,HCS_Appointment_Type_Inbound__c,Appointment_Type__c from Case where Id =:cs.Id];
        System.assertNotEquals('FDO', res.Appointment_Type__c);
    }
}
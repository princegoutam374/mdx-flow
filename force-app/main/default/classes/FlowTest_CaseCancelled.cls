@isTest
public with sharing class FlowTest_CaseCancelled {
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

        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('BMS').getRecordTypeId();
        Case cs = new Data.CaseBuilder()
        .newCase()
        .setAccountId(acc.Id)
        .setRecordTypeId(recordTypeId)
        .setReferringProvider(acc.Id)
        .doInsert()
        .cs;

        sked__Job__c jb = new Data.JobBuilder()
        .newJob()
        .setDuration(10)
        .setRegion(region.Id)
        .setCase(cs.Id)
        .doInsert()
        .job;
        
    }

    /*
    * Type: Flow
    * Name: Case - Cancelled - V1
    * Scenario: Set Case Status to Cancelled, then associated job status will be set to Cancelled
    */
    @isTest
    static void testCaseCancelled(){
        Case cs = [Select Id,Status,Cancellation_Reason__c from Case limit 1];
        cs.Status = 'Cancelled';
        cs.Cancellation_Reason__c = 'Government';
        update cs;

        sked__Job__c jb = [Select Id, sked__Job_Status__c from sked__Job__c where Case__c =: cs.Id];
        System.debug('jb ## '+jb);
    }

    /*
    * Type: Flow
    * Name: Case - Cancelled - V1
    * Scenario: Set Case Status to Cancelled, then associated job status will be set to Cancelled
    */
    @isTest
    static void testCaseCancelledNegativeScenario(){
        Case cs = [Select Id,Status,Cancellation_Reason__c from Case limit 1];
        cs.Status = 'Med List Review';
        update cs;

        sked__Job__c jb = [Select Id, sked__Job_Status__c from sked__Job__c where Case__c =: cs.Id];
        System.assertNotEquals('Cancelled', jb.sked__Job_Status__c);
    }
}
@isTest
public with sharing class FlowTest_XMayzentFlow {
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
        .setHCSPatientId('TestHCSPatient')
        .doInsert()
        .account;
    }

    /*
    * Type: Process Builder
    * Name: XMayzent Flow
    * Node: MAYZENT Case
    * Scenario: Create a case with MAYZENT-BA record type, and set the HCS Patient ID on Account,
    * should set the Patient ID Plain Text to HCS Patient ID of account
    */
    @isTest
    public static void testMayzentCasePositiveScenario(){
        Account acc = [SELECT Id,HCS_Patient_Id__c FROM Account];
        
        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('MAYZENT - BA').getRecordTypeId();
        Case cs = new Data.CaseBuilder()
        .newCase()
        .setAccountId(acc.Id)
        .setRecordTypeId(recordTypeId)
        .doInsert()
        .cs;
        
        Case mayzentCase = [Select Id,Patient_ID_Plain_Text__c, Account.HCS_Patient_Id__c from Case where Id =:cs.Id];
        System.assertEquals(mayzentCase.Account.HCS_Patient_Id__c, mayzentCase.Patient_ID_Plain_Text__c);
    }

    /*
    * Type: Process Builder
    * Name: XMayzent Flow
    * Node: MAYZENT Case
    * Scenario: Create a case with not MAYZENT-BA record type, and set the HCS Patient ID on Account,
    * should not set the Patient ID Plain Text to HCS Patient ID of account
    */
    @isTest
    public static void testMayzentCaseNegativeScenario(){
        Account acc = [SELECT Id,HCS_Patient_Id__c FROM Account];
        
        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ZEPOSIA - GASTRO').getRecordTypeId();
        Case cs = new Data.CaseBuilder()
        .newCase()
        .setAccountId(acc.Id)
        .setRecordTypeId(recordTypeId)
        .doInsert()
        .cs;
        
        Case mayzentCase = [Select Id,Patient_ID_Plain_Text__c from Case];
        System.assertEquals(null, mayzentCase.Patient_ID_Plain_Text__c);
    }
}
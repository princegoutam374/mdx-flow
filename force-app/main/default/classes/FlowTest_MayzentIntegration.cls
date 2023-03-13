@isTest
public with sharing class FlowTest_MayzentIntegration {
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
        .setHCSPatientId('612435')
        .doInsert()
        .account;
    }

    /*
    * Type: Flow
    * Name: Mayzent Integration- V4
    * Node: Integration
    * Case: Put
    * Scenario: Record Type is Mayzent and Appointment ID is not null
    */
    @isTest
    static void testPutScenario(){
        Account acc = [SELECT Id,HCS_Patient_Id__c FROM Account];

        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('MAYZENT - BA').getRecordTypeId();
        try{
            Case cs = new Data.CaseBuilder()
            .newCase()
            .setAccountId(acc.Id)
            .setRecordTypeId(recordTypeId)
            .setAppointmentId('Test123434')
            .doInsert()
            .cs;
            
            Case mayzentCase = [Select Id, Status from Case where Id =: cs.Id limit 1];
            mayzentCase.Status  = 'Med List Review';
            
            update mayzentCase;   
        }catch(Exception ex){
            if(ex.getMessage().contains('Null Pointer')){
                System.debug('exception');
            }
        }  
    }

    /*
    * Type: Flow
    * Name: Mayzent Integration- V4
    * Node: Integration
    * Case: Post
    * Scenario: Record Type is Mayzent and Appointment ID is null
    */
    @isTest
    static void testPostScenario(){
        Account acc = [SELECT Id,HCS_Patient_Id__c FROM Account];
        
        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('MAYZENT - BA').getRecordTypeId();
        try{
            Case cs = new Data.CaseBuilder()
            .newCase()
            .setAccountId(acc.Id)
            .setRecordTypeId(recordTypeId)
            .doInsert()
            .cs;
            
            Case mayzentCase = [Select Id, Status from Case where Id =: cs.Id limit 1];
            mayzentCase.Status  = 'Med List Review';
        
            update mayzentCase;   
        }catch(Exception ex){
            if(ex.getMessage().contains('Null Pointer')){
                System.debug('exception');
            }
        } 
    }

    /*
    * Type: Flow
    * Name: Mayzent Integration- V4
    * Node: Integration
    * Case: Default
    * Scenario: Record Type is Mayzent, then set Debug Text to Default
    */
    @isTest
    static void testDefaultScenario(){
        Account acc = [SELECT Id,HCS_Patient_Id__c FROM Account];
        
        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('MAYZENT - BA').getRecordTypeId();
        try{
            Case cs = new Data.CaseBuilder()
            .newCase()
            .setAccountId(acc.Id)
            .setRecordTypeId(recordTypeId)
            .doInsert()
            .cs;
        }catch(Exception ex){
            if(ex.getMessage().contains('Null Pointer')){
                System.debug('exception');
            }
        } 
    }
}
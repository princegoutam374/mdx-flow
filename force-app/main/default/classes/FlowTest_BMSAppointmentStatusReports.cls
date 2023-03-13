@isTest
public with sharing class FlowTest_BMSAppointmentStatusReports {
    @TestSetup
    static void createData(){
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
        .setSMSOptOut(false)
        .doInsert()
        .account;

        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ZEPOSIA - GASTRO').getRecordTypeId();
        Case cs = new Data.CaseBuilder()
        .newCase()
        .setAccountId(acc.Id)
        .setRecordTypeId(recordTypeId)
        .setPatientSMSOptOut(false)
        .doInsert()
        .cs;
    }

    /*
    * Type: Flow
    * Name: BMS Appointment Status Reports
    * Node: Preferred Dates Received
    * Scenario: Preferred_Date_1__c is not null, Confirm_Clinician__c set to true, Appointment_Confirmation_Status__c set to Confirmed, 
        Appointment_Status_Lash__c should be 'Appointment Changed', Preferred_Dates_Received_Date__c should be set to today,
        Staff_Confirmed_Date__c should be set to today,Patient_and_Staff_Confirmed_Date__c should be set to today
    */
    @isTest
    static void testPreferredDateReceived(){
        List<Case> cs = [Select Id, Preferred_Date_1__c,Confirm_Clinician__c,Appointment_Confirmation_Status__c from Case limit 1];
        cs[0].Preferred_Date_1__c = System.today();
        cs[0].Confirm_Clinician__c = true;
        cs[0].Appointment_Confirmation_Status__c = 'Confirmed';
        update cs;

        List<Case> res = [Select Id,Preferred_Dates_Received_Date__c,Staff_Confirmed_Date__c,Appointment_Status_Lash__c,Patient_and_Staff_Confirmed_Date__c
                        from Case where Id =:cs[0].Id];
        System.assertEquals(System.today(), res[0].Preferred_Dates_Received_Date__c);
        System.assertEquals(System.today(), res[0].Staff_Confirmed_Date__c);
        System.assertEquals('Appointment Changed', res[0].Appointment_Status_Lash__c);
        System.assertEquals(System.today(), res[0].Patient_and_Staff_Confirmed_Date__c);
    }
}
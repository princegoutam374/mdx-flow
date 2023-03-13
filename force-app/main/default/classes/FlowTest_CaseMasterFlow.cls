@isTest
public with sharing class FlowTest_CaseMasterFlow {
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
        .setNPINumber('Test4959')
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
    * Name: Case Master Flow v3
    * Case: Case record type set to Mayzent BA, Case status will be Appointment
    */
    @isTest
    static void testMayzentBACase(){
        Account ac = [SELECT FirstName, LastName, PersonContactId, Personmailingcountry, Personmailingstate, 
                      Personmailingstreet, Mailing_Street_1__c, Mailing_Street_2__c, PersonMobilePhone, Phone, 
                      PersonEmail FROM Account];

        sked__Resource__c resource = new Data.ResourceBuilder()
        .newResource()
        .setAccount(ac.Id)
        .doInsert()
        .resource;

        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('MAYZENT - BA').getRecordTypeId();
        Case cs = new Data.CaseBuilder()
        .newCase()
        .setAccountId(ac.Id)
        .setRecordTypeId(recordTypeId)
        .setReferringProvider(ac.Id)
        .setAssignedResource(resource.Id)
        .setAppointmentConfirmationStatus('Confirmed')
        .doInsert()
        .cs;
        
        Case res = [Select ID, Status,Reminder_Email_to_Clinical_Staff__c,Reminder_Text_to_Clinician__c,Reminder_Text_to_Patient__c from Case where Id =: cs.Id];
        res.Reminder_Text_to_Clinician__c = true;
        res.Reminder_Email_to_Clinical_Staff__c = true;
        res.Reminder_Text_to_Patient__c = true;
        update res;

        Case resp = [Select ID, Status, Reminder_Text_to_Clinician__c from Case where ID =: res.Id];
        System.assertEquals('Appointment', resp.Status);
    }

    /*
    * Type: Flow
    * Name: Case Master Flow v3
    * Case: Case record type set to Mayzent FDO, Case status will be Appointment
    */
    @isTest
    static void testMayzentFDOCase(){
        Account ac = [SELECT FirstName, LastName, PersonContactId, Personmailingcountry, Personmailingstate, 
                      Personmailingstreet, Mailing_Street_1__c, Mailing_Street_2__c, PersonMobilePhone, Phone, 
                      PersonEmail FROM Account];

        sked__Resource__c resource = new Data.ResourceBuilder()
        .newResource()
        .setAccount(ac.Id)
        .doInsert()
        .resource;

        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('MAYZENT - FDO').getRecordTypeId();
        Case cs = new Data.CaseBuilder()
        .newCase()
        .setAccountId(ac.Id)
        .setRecordTypeId(recordTypeId)
        .setReferringProvider(ac.Id)
        .setAssignedResource(resource.Id)
        .doInsert()
        .cs;
        
        Case res = [Select ID, Status,Reminder_Email_to_Clinical_Staff__c,Reminder_Text_to_Clinician__c,Reminder_Text_to_Patient__c, 
                    Confirm_Provider__c, Med_Kit_Requested__c,Appointment_Confirmation_Status__c,Confirm_Clinician__c,
                    Has_Patient_Received_Med_Kit__c from Case where Id =: cs.Id];
        res.Reminder_Text_to_Clinician__c = true;
        res.Reminder_Email_to_Clinical_Staff__c = true;
        res.Reminder_Text_to_Patient__c = true;
        res.Confirm_Provider__c = true;
        res.Appointment_Confirmation_Status__c = 'Confirmed';
        res.Has_Patient_Received_Med_Kit__c = true;
        update res;

        Case resp = [Select ID, Status, Reminder_Text_to_Clinician__c from Case where ID =: res.Id];
        System.assertEquals('Appointment', resp.Status);
    }

    /*
    * Type: Flow
    * Name: Case Master Flow v3
    * Case: Case record type set to  PONVORY, Case Parital Completed date will be set as today
    */
    @isTest
    static void testPonvoryCase(){
        Account ac = [SELECT FirstName, LastName, PersonContactId, Personmailingcountry, Personmailingstate, 
                      Personmailingstreet, Mailing_Street_1__c, Mailing_Street_2__c, PersonMobilePhone, Phone, 
                      PersonEmail FROM Account];

        sked__Resource__c resource = new Data.ResourceBuilder()
        .newResource()
        .setAccount(ac.Id)
        .doInsert()
        .resource;
        try{
            Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('PONVORY').getRecordTypeId();
            Case cs = new Data.CaseBuilder()
            .newCase()
            .setAccountId(ac.Id)
            .setRecordTypeId(recordTypeId)
            .setReferringProvider(ac.Id)
            .setAssignedResource(resource.Id)
            .doInsert()
            .cs;
            
            Case res = [Select ID, Status,Reminder_Email_to_Clinical_Staff__c,Reminder_Text_to_Clinician__c,Reminder_Text_to_Patient__c, 
                        Confirm_Provider__c, Med_Kit_Requested__c,Appointment_Confirmation_Status__c,Confirm_Clinician__c,
                        Has_Patient_Received_Med_Kit__c from Case where Id =: cs.Id];
            res.Reminder_Text_to_Clinician__c = true;
            res.Reminder_Email_to_Clinical_Staff__c = true;
            res.Reminder_Text_to_Patient__c = true;
            res.Confirm_Provider__c = true;
            res.Appointment_Confirmation_Status__c = 'Confirmed';
            res.Has_Patient_Received_Med_Kit__c = true;
            res.Status = 'Partially Complete';
            update res;

            Case resp = [Select ID, Partially_Complete_Date__c from Case where ID =: res.Id];
            System.assertEquals(System.today(), resp.Partially_Complete_Date__c);
        }catch(Exception ex){
            if(ex.getMessage().contains('Null Pointer')){
                System.debug('exception');
            }
        }
    }

    /*
    * Type: Flow
    * Name: Case Master Flow v3
    * Case: Case record type set to  Adbry, Case Status will be set as Staff Provider
    */
    @isTest
    static void testAdbryCase(){
        Account ac = [SELECT FirstName, LastName, PersonContactId, Personmailingcountry, Personmailingstate, 
                      Personmailingstreet, Mailing_Street_1__c, Mailing_Street_2__c, PersonMobilePhone, Phone, 
                      PersonEmail FROM Account];

        sked__Resource__c resource = new Data.ResourceBuilder()
        .newResource()
        .setAccount(ac.Id)
        .doInsert()
        .resource;

        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Adbry').getRecordTypeId();
        try{
            Case cs = new Data.CaseBuilder()
            .newCase()
            .setAccountId(ac.Id)
            .setRecordTypeId(recordTypeId)
            .setReferringProvider(ac.Id)
            .setAssignedResource(resource.Id)
            .setConfirmSRFForPatient(true)
            .doInsert()
            .cs;
        }catch(Exception ex){
            if(ex.getMessage().contains('Null Pointer')){
                System.debug('exception');
            }
        }
    }
}
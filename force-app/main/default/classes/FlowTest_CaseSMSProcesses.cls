@isTest
public with sharing class FlowTest_CaseSMSProcesses {
    @TestSetup
    static void createAccount(){
        Id rtId = [SELECT Id FROM RecordType WHERE IsPersonType = TRUE AND SObjectType='Account' LIMIT 1].Id;
        Account acc= new Account();
        acc.FirstName= 'Dan';
        acc.LastName='Smith';
        acc.Personmailingcountry= 'Canada';
        acc.Personmailingstate = 'New Brunswick';
        acc.Personmailingstreet = 'New Brunswick';
        acc.Mailing_Street_1__c = '4206 Minnesota';
        acc.Mailing_Street_2__c = 'Pine Apt. 165';
        acc.PersonMobilePhone = '1111111';
        acc.Phone = '2222222';
        acc.PersonEmail = 'test@test.com';
        acc.Consent_To_Text__c  = 'Yes';
        acc.Fax = '21212121';
        acc.Office_Contact_Email__c = 'abc@test.com';
        acc.Office_Contact_Name__c = 'Test Office Contact';
        acc.RecordTypeId=rtId;
        acc.smagicinteract__SMSOptOut__pc = false;
        insert acc;
    }

    /*
    * Type: Process Builder
    * Name: Case SMS Processes
    * Node: Patient Initial
    * Scenario: Patient SMS Opt to false, Send Initial Text to false, Appointment date time not be blank, should set Send Initial Text to true
    */  
    @isTest
    static void testPatientInitialPositiveScenario(){
        Account ac = [SELECT Id FROM Account];
        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ZEPOSIA - GASTRO').getRecordTypeId();
        Case cs = new Case();
        cs.RecordTypeId = recordTypeId;
        cs.AccountId = ac.Id;
        cs.Patient_SMS_Opt_Out__c = false;
        cs.Preferred_Timing_3__c = '11:00 AM EST';
        cs.Send_Initial_Text__c = false;
        cs.Appointment_Date_Time__c = System.now();
        insert cs;
        
        Case patientCase = [Select Id, Send_Initial_Text__c from Case where Id =: cs.Id];
        System.assertEquals(true, patientCase.Send_Initial_Text__c);
    }

    /*
    * Type: Process Builder
    * Name: Case SMS Processes
    * Node: Patient Initial
    * Scenario: Appointment date time be blank, should set Send Initial Text to false
    */
    @isTest
    static void testPatientInitialNegativeScenario(){
        Account ac = [SELECT Id FROM Account];
        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ZEPOSIA - GASTRO').getRecordTypeId();
        Case cs = new Case();
        cs.RecordTypeId = recordTypeId;
        cs.AccountId = ac.Id;
        insert cs;
        
        Case patientCase = [Select Id, Send_Initial_Text__c from Case where Id =: cs.Id];
        System.assertEquals(false, patientCase.Send_Initial_Text__c);
    }

    /*
    * Type: Process Builder
    * Name: Case SMS Processes
    * Node: Patient Confirmation
    * Scenario: Appointment Confirmation Status changed and set to 'Send Confirmation Text', should create a converse app task
    */
    @isTest
    static void testPatientConfirmationPositiveScenario(){
        Account ac = [SELECT Id FROM Account];
        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ZEPOSIA - GASTRO').getRecordTypeId();
        Case cs = new Case();
        cs.RecordTypeId = recordTypeId;
        cs.AccountId = ac.Id;
        cs.Appointment_Confirmation_Status__c = 'Pending';
        insert cs;
        
        Case patientCase = [Select Id, Appointment_Confirmation_Status__c from Case where Id =: cs.Id];
        patientCase.Appointment_Confirmation_Status__c = 'Send Confirmation Text';
        update patientCase;
        smagicinteract__Converse_App_Task__c tsk = [Select Id from smagicinteract__Converse_App_Task__c];
        System.assertNotEquals(null, tsk);
    }

    /*
    * Type: Process Builder
    * Name: Case SMS Processes
    * Node: Patient Confirmation
    * Scenario: Appointment Confirmation Status changed and set to 'Pending', should not create a converse app task
    */
    @isTest
    static void testPatientConfirmationNegativeScenario(){
        Account ac = [SELECT Id FROM Account];
        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ZEPOSIA - GASTRO').getRecordTypeId();
        Case cs = new Case();
        cs.RecordTypeId = recordTypeId;
        cs.AccountId = ac.Id;
        cs.Appointment_Confirmation_Status__c = 'Send Confirmation Text';
        insert cs;
        
        Case patientCase = [Select Id, Appointment_Confirmation_Status__c from Case where Id =: cs.Id];
        patientCase.Appointment_Confirmation_Status__c = 'Pending';
        update patientCase;
        List<smagicinteract__Converse_App_Task__c> tsk = [Select Id from smagicinteract__Converse_App_Task__c];
        System.assertNotEquals(1, tsk.size());
    }

    /*
    * Type: Process Builder
    * Name: Case SMS Processes
    * Node: ZEPOSIA Reminder (Clinical)
    * Scenario: Assigned Resource Phone not blank, Reminder Text to Clinician is changed and set to true, 
    * should create a converse app task record with Automation key Reference set to PA-00012
    */
    @isTest
    static void testZeposiaReminderClinicianPositiveScenario(){
        Account ac = [SELECT Id FROM Account];
        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ZEPOSIA - GASTRO').getRecordTypeId();
        Case cs = new Case();
        cs.RecordTypeId = recordTypeId;
        cs.AccountId = ac.Id;
        cs.Assigned_Resource_Phone__c = '1234567890';
        cs.Reminder_Text_to_Clinician__c = false;
        insert cs;
        
        Case zeposiaCase = [Select Id, Reminder_Text_to_Clinician__c from Case where Id =: cs.Id];
        zeposiaCase.Reminder_Text_to_Clinician__c = true;
        update zeposiaCase;
        List<smagicinteract__Converse_App_Task__c> tsk = [Select Id,smagicinteract__Automation_Key_Reference__c,case__c from smagicinteract__Converse_App_Task__c];
        System.assertEquals('PA-000012', tsk[0].smagicinteract__Automation_Key_Reference__c);
        System.assertEquals(zeposiaCase.Id, tsk[0].case__c);
    }

    /*
    * Type: Process Builder
    * Name: Case SMS Processes
    * Node: ZEPOSIA Reminder (Clinical)
    * Scenario: Assigned Resource Phone not blank, Reminder Text to Clinician is set to false, 
    * should not create a converse app task record
    */
    @isTest
    static void testZeposiaReminderClinicianNegativeScenario(){
        Account ac = [SELECT Id FROM Account];
        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ZEPOSIA - GASTRO').getRecordTypeId();
        Case cs = new Case();
        cs.RecordTypeId = recordTypeId;
        cs.AccountId = ac.Id;
        cs.Assigned_Resource_Phone__c = '1234567890';
        cs.Reminder_Text_to_Clinician__c = false;
        insert cs;
        
        List<smagicinteract__Converse_App_Task__c> tsk = [Select Id,smagicinteract__Automation_Key_Reference__c,case__c from smagicinteract__Converse_App_Task__c];
        System.assertEquals(0, tsk.size());
    }

    /*
    * Type: Process Builder
    * Name: Case SMS Processes
    * Node: ZEPOSIA Reminder (Patient)
    * Scenario: Reminder Text to Clinician is changed and set to true, Patient SMS Opt Out to false
    * should create a converse app task record with Automation key Reference set to PA-00011
    */
    @isTest
    static void testZeposiaReminderPatientPositiveScenario(){
        Account ac = [SELECT Id FROM Account];
        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ZEPOSIA - GASTRO').getRecordTypeId();
        Case cs = new Case();
        cs.RecordTypeId = recordTypeId;
        cs.AccountId = ac.Id;
        cs.Assigned_Resource_Phone__c = '1234567890';
        cs.Reminder_Text_to_Patient__c = false;
        cs.Patient_SMS_Opt_Out__c = false;
        insert cs;
        
        Case zeposiaCase = [Select Id, Reminder_Text_to_Patient__c from Case where Id =: cs.Id];
        zeposiaCase.Reminder_Text_to_Patient__c = true;
        update zeposiaCase;
        List<smagicinteract__Converse_App_Task__c> tsk = [Select Id,smagicinteract__Automation_Key_Reference__c,case__c from smagicinteract__Converse_App_Task__c];
        System.assertEquals('PA-000011', tsk[0].smagicinteract__Automation_Key_Reference__c);
        System.assertEquals(zeposiaCase.Id, tsk[0].case__c);
    }

    /*
    * Type: Process Builder
    * Name: Case SMS Processes
    * Node: ZEPOSIA Reminder (Patient)
    * Scenario: Reminder Text to Clinician is set to false
    * should not create a converse app task record
    */
    @isTest
    static void testZeposiaReminderPatientNegativeScenario(){
        Account ac = [SELECT Id FROM Account];
        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ZEPOSIA - GASTRO').getRecordTypeId();
        Case cs = new Case();
        cs.RecordTypeId = recordTypeId;
        cs.AccountId = ac.Id;
        cs.Assigned_Resource_Phone__c = '1234567890';
        cs.Reminder_Text_to_Patient__c = false;
        insert cs;
        
        List<smagicinteract__Converse_App_Task__c> tsk = [Select Id,smagicinteract__Automation_Key_Reference__c,case__c from smagicinteract__Converse_App_Task__c];
        System.assertEquals(0, tsk.size());
    }
}
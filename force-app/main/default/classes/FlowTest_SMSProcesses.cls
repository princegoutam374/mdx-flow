@isTest
public with sharing class FlowTest_SMSProcesses {
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
        .setStatus('Complete')
        .doInsert()
        .cs;

        smagicinteract__Converse_App__c converseApp = new Data.ConverseAppBuilder()
        .newConverseApp()
        .setName('Test')
        .doInsert()
        .converseApp;
    }

    /*
    * Type: Process Builder
    * Name: SMS Processes
    * Node: Case Cancelled  
    * Scenario: CaseStatus set to Cancelled, Direction of SMS History associated with Case to IN and case record type to ZEPOSIA - GASTRO,
    * should set Automation key reference on Converse App task to PA-000011
    */
    @isTest
    static void testCaseCancelledPositiveScenario(){
        Account ac = [SELECT Id FROM Account];
        Case cs = [Select Id,Assigned_Resource_Phone__c,Reminder_Text_to_Patient__c, Status from Case];
        cs.Assigned_Resource_Phone__c = '1234567890';
        cs.Reminder_Text_to_Patient__c = true;
        update cs;

        smagicinteract__smsMagic__c sms = new Data.SMSBuilder()
        .newSms()
        .setCase(cs.Id)
        .setDirection('IN')
        .setPhone('1234512345')
        .setSmsText('test sms')
        .setSender('Test12334')
        .setExternalField('unique')
        .doInsert()
        .sms;
		
        List<smagicinteract__Converse_App_Task__c> tsk = [Select Id,smagicinteract__Automation_Key_Reference__c,case__c from smagicinteract__Converse_App_Task__c];
        System.assertEquals('PA-000011', tsk[0].smagicinteract__Automation_Key_Reference__c);
        System.assertEquals(cs.Id, tsk[0].case__c);
    }
    
    /*
    * Type: Process Builder
    * Name: SMS Processes
    * Node: Case Cancelled  
    * Scenario: CaseStatus not set to Cancelled, Direction of SMS History associated with Case to IN and case record type to ZEPOSIA - GASTRO,
    * should not set Automation key reference on Converse App task to PA-000011
    */
    @isTest
    static void testCaseCancelledNegativeScenario(){
        Account acc = [SELECT Id FROM Account];

        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ZEPOSIA - GASTRO').getRecordTypeId();
        Case cs = new Data.CaseBuilder()
        .newCase()
        .setAccountId(acc.Id)
        .setRecordTypeId(recordTypeId)
        .setPatientSMSOptOut(false)
        .setAssignedResourcePhone('1234567890')
        .setReminderTextToPatient(false)
        .doInsert()
        .cs;

        smagicinteract__smsMagic__c sms = new Data.SMSBuilder()
        .newSms()
        .setDirection('IN')
        .setPhone('1234512345')
        .setSmsText('test sms')
        .setSender('Test12334')
        .setExternalField('unique')
        .doInsert()
        .sms;
		
        List<smagicinteract__Converse_App_Task__c> tsk = [Select Id,smagicinteract__Automation_Key_Reference__c,case__c from smagicinteract__Converse_App_Task__c];
        System.assertEquals(0, tsk.size());
    }
    
    /*
    * Type: Process Builder
    * Name: SMS Processes
    * Node: Patient Confirmation (Response)
    * Scenario: Direction on SMS History associated to case set to IN, SMS Text to Yes, 
    * should set Pharmacord Activity date on case to today
    */
    @isTest
    static void testPatientConfirmationPositiveScenario(){
        Case cs = [Select Id, Status from Case Limit 1];

        smagicinteract__smsMagic__c sms = new Data.SMSBuilder()
        .newSms()
        .setCase(cs.Id)
        .setDirection('IN')
        .setPhone('1234512345')
        .setSmsText('Yes')
        .setSender('Test12334')
        .setExternalField('test')
        .doInsert()
        .sms;
        
        Case result = [Select Id, Appointment_Confirmation_Status__c,Pharmacord_Activity_Name__c,Pharmacord_Activity_Status__c,Pharmacord_Activity_Date__c from Case where Id =: sms.smagicinteract__Case__c limit 1];
        System.assertEquals(System.today(), result.Pharmacord_Activity_Date__c);
    }
    
    /*
    * Type: Process Builder
    * Name: SMS Processes
    * Node: Patient Confirmation (Response)
    * Scenario: Direction on SMS History associated to case not set to IN, SMS Text to Yes, 
    * should not set Appointment Confirmation Status to Confirmed
    */
    @isTest
    static void testPatientConfirmationNegativeScenario(){
        Case cs = [Select Id, Status from Case Limit 1];

        smagicinteract__smsMagic__c sms = new Data.SMSBuilder()
        .newSms()
        .setCase(cs.Id)
        .setPhone('1234512345')
        .setSmsText('Yes')
        .setSender('Test12334')
        .setExternalField('test')
        .doInsert()
        .sms;
        
        Case result = [Select Id, Appointment_Confirmation_Status__c,Pharmacord_Activity_Name__c,Pharmacord_Activity_Status__c,Pharmacord_Activity_Date__c from Case where Id =: sms.smagicinteract__Case__c limit 1];
        System.assertNotEquals('Confirmed', result.Appointment_Confirmation_Status__c);
    }
    
    /*
    * Type: Process Builder
    * Name: SMS Processes
    * Node: Patient Initial (Auto)
    * Scenario: Converse Action Name associated to SMS History set to ZEPOSIA Patient Initial Text and Direction on SMS History set to OUT,
    * should set Pateint Scheduling Status on Case to Completed and First Automated Text to SMS History ID
    */
    @isTest
    static void testPatientInitialPositiveScenario(){
        Case cs = [Select Id, Status from Case Limit 1];

        smagicinteract__Converse_App__c converseApp = [Select Id from smagicinteract__Converse_App__c limit 1];

        smagicinteract__Converse_App_Action__c  converseAppAction = new Data.ConverseAppActionBuilder()
        .newConverseAppAction()
        .setName('ZEPOSIA Patient Initial Text')
        .setConverseApp(converseApp.Id)
        .setMobilePhoneField('13243435454')
        .doInsert()
        .converseAppAction;

        smagicinteract__smsMagic__c sms = new Data.SMSBuilder()
        .newSms()
        .setCase(cs.Id)
        .setDirection('OUT')
        .setPhone('1234512345')
        .setSmsText('S')
        .setSender('Test12334')
        .setExternalField('test')
        .setConverseAppAction(converseAppAction.Id)
        .doInsert()
        .sms;
        
        Case result = [Select Id, Patient_Scheduling_Status__c,First_Automated_Text__c from Case where Id =: sms.smagicinteract__Case__c limit 1];
        System.assertEquals('Completed', result.Patient_Scheduling_Status__c);
        System.assertEquals(sms.Id, result.First_Automated_Text__c);
    }
    
    /*
    * Type: Process Builder
    * Name: SMS Processes
    * Node: Patient Initial (Auto)
    * Scenario: Converse Action Name associated to SMS History not set to ZEPOSIA Patient Initial Text and Direction on SMS History set to OUT,
    * should not set Pateint Scheduling Status on Case to Completed and First Automated Text not to SMS History ID
    */
    @isTest
    static void testPatientInitialNegativeScenario(){
        Case cs = [Select Id, Status from Case Limit 1];
        
        smagicinteract__Converse_App__c converseApp = [Select Id from smagicinteract__Converse_App__c limit 1];

        smagicinteract__Converse_App_Action__c  converseAppAction = new Data.ConverseAppActionBuilder()
        .newConverseAppAction()
        .setName('ZEPOSIA Patient Initial')
        .setConverseApp(converseApp.Id)
        .setMobilePhoneField('13243435454')
        .doInsert()
        .converseAppAction;

        smagicinteract__smsMagic__c sms = new Data.SMSBuilder()
        .newSms()
        .setCase(cs.Id)
        .setDirection('OUT')
        .setPhone('1234512345')
        .setSmsText('S')
        .setSender('Test12334')
        .setExternalField('test')
        .setConverseAppAction(converseAppAction.Id)
        .doInsert()
        .sms;
        
        Case result = [Select Id, Patient_Scheduling_Status__c,First_Automated_Text__c from Case where Id =: sms.smagicinteract__Case__c limit 1];
        System.assertNotEquals('Completed', result.Patient_Scheduling_Status__c);
        System.assertNotEquals(sms.Id, result.First_Automated_Text__c);
    }
    
    /*
    * Type: Process Builder
    * Name: SMS Processes
    * Node: Patient Confirmation (Auto)
    * Scenario: Converse Action Name associated to SMS History set to Patient Appointment Confirmation Text and Direction on SMS History set to OUT,
    * should set Appointment Confirmation Status on Case to Confirmation Text Sent
    */
    @isTest
    static void testPatientConfirmationAutoPositiveScenario(){
        Case cs = [Select Id, Status from Case Limit 1];
        
        smagicinteract__Converse_App__c converseApp = [Select Id from smagicinteract__Converse_App__c limit 1];

        smagicinteract__Converse_App_Action__c  converseAppAction = new Data.ConverseAppActionBuilder()
        .newConverseAppAction()
        .setName('Patient Appointment Confirmation Text')
        .setConverseApp(converseApp.Id)
        .setMobilePhoneField('13243435454')
        .doInsert()
        .converseAppAction;

        smagicinteract__smsMagic__c sms = new Data.SMSBuilder()
        .newSms()
        .setCase(cs.Id)
        .setDirection('OUT')
        .setPhone('1234512345')
        .setSmsText('Send')
        .setSender('Test12334')
        .setExternalField('test')
        .setConverseAppAction(converseAppAction.Id)
        .doInsert()
        .sms;
        
        Case result = [Select Id, Appointment_Confirmation_Status__c,Latest_Text__c from Case where Id =: sms.smagicinteract__Case__c limit 1];
        System.assertEquals('Confirmation Text Sent', result.Appointment_Confirmation_Status__c);
        System.assertEquals(sms.Id, result.Latest_Text__c);
    }
    
    /*
    * Type: Process Builder
    * Name: SMS Processes
    * Node: Patient Confirmation (Auto)
    * Scenario: Converse Action Name associated to SMS History not set to Patient Appointment Confirmation Text and Direction on SMS History set to OUT,
    * should not set Appointment Confirmation Status on Case to Confirmation Text Sent
    */
    @isTest
    static void testPatientConfirmationAutoNegativeScenario(){
        Case cs = [Select Id, Status from Case Limit 1];
        
        smagicinteract__Converse_App__c converseApp = [Select Id from smagicinteract__Converse_App__c limit 1];

        smagicinteract__Converse_App_Action__c  converseAppAction = new Data.ConverseAppActionBuilder()
        .newConverseAppAction()
        .setName('Patient Appointment Confirmation')
        .setConverseApp(converseApp.Id)
        .setMobilePhoneField('13243435454')
        .doInsert()
        .converseAppAction;

        smagicinteract__smsMagic__c sms = new Data.SMSBuilder()
        .newSms()
        .setCase(cs.Id)
        .setDirection('OUT')
        .setPhone('1234512345')
        .setSmsText('Send')
        .setSender('Test12334')
        .setExternalField('test')
        .setConverseAppAction(converseAppAction.Id)
        .doInsert()
        .sms;
        
        Case result = [Select Id, Appointment_Confirmation_Status__c,Latest_Text__c from Case where Id =: sms.smagicinteract__Case__c limit 1];
        System.assertNotEquals('Confirmation Text Sent', result.Appointment_Confirmation_Status__c);
        System.assertNotEquals(sms.Id, result.Latest_Text__c);
    }
}
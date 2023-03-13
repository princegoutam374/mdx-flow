@isTest
public with sharing class FlowTest_SMSHistoryMaster {
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
        //.setStatus('Complete')
        .doInsert()
        .cs;

        smagicinteract__Converse_App__c converseApp = new Data.ConverseAppBuilder()
        .newConverseApp()
        .setName('Test')
        .doInsert()
        .converseApp;
        
        smagicinteract__Converse_App_Action__c  converseAppAction = new Data.ConverseAppActionBuilder()
        .newConverseAppAction()
        .setName('ZEPOSIA Patient Initial Text')
        .setConverseApp(converseApp.Id)
        .setMobilePhoneField('13243435454')
        .doInsert()
        .converseAppAction;
        
        smagicinteract__smsMagic__c sms = new Data.SMSBuilder()
        	.newSms()
            .setDirection('IN')
            .setPhone('1234512345')
            .setSmsText('Yes')
            .setSender('Test12334')
            .setExternalField('unique')
            .setConverseAppAction(converseAppAction.Id)
            .doInsert()
            .sms;

    }

    @isTest
    static void testZeposiaCase(){
        Account ac = [SELECT Id FROM Account];
        Case cs = [Select Id,Assigned_Resource_Phone__c,Reminder_Text_to_Patient__c, Status from Case];
        smagicinteract__smsMagic__c smsHistory = [Select id from smagicinteract__smsMagic__c limit 1];

        smagicinteract__smsMagic__c sms = new Data.SMSBuilder()
        .newSms()
        .setCase(cs.Id)
        .setDirection('IN')
        .setPhone('1234512345')
        .setSmsText('Yes')
        .setSender('Test12334')
        .setExternalField('unique')
        //.setPreviousMessage(smsHistory.Id)
        .doInsert()
        .sms;
		
        List<Case> res = [Select ID, Appointment_Confirmation_Status__c from Case where Id =: cs.Id];
        System.assertEquals('Confirmed',res[0].Appointment_Confirmation_Status__c);
    }
}
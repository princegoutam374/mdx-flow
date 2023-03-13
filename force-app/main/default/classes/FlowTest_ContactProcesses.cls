@isTest
public with sharing class FlowTest_ContactProcesses {
    @TestSetup
    static void createContact(){        
        Contact con = new Data.ContactBuilder()
        .newContact()
        .setFirstName('Dan')
        .setLastName('Smith')
        .setMobilePhone('1234567890')
        .doInsert()
        .con;
        
        smagicinteract__Consent__c consent = new Data.ConsentBuilder()
        .newConsent()
        .setContact(con.Id)
        .doInsert()
        .consent;
    }

    /*
    * Type: Process Builder
    * Name: Contact Processes
    * Node: SMS Opt Out
    * Scenario: sms opt out set to true on contact, compliance status should be set to Opt-out, do not send confirmation to true 
    * and send confirmation message to false 
    */  
    @isTest
    static void testSMSOptOutCase(){
        list<Contact> conList = new List<Contact>();
        conList = [select id,smagicinteract__SMSOptOut__c from Contact];
        Boolean smsOptOut=conList[0].smagicinteract__SMSOptOut__c;
        conList[0].smagicinteract__SMSOptOut__c = true;
        test.startTest();
        update conList;
        test.stopTest();
        List<smagicinteract__Consent__c> consent = [Select Id,smagicinteract__Compliance_Status__c,smagicinteract__Do_Not_Send_Confirmation__c,smagicinteract__Send_Confirmation_Message__c from smagicinteract__Consent__c where smagicinteract__Contact__c =:conList[0].Id];
        system.assertEquals(consent[0].smagicinteract__Compliance_Status__c,'Opt-Out','Patient Opt Out of SMS' );
        system.assertEquals(consent[0].smagicinteract__Do_Not_Send_Confirmation__c,true,'Do not send confirmation' );
        system.assertEquals(consent[0].smagicinteract__Send_Confirmation_Message__c,false,'Send Confirmation Message' );
        
    }
    
    /*
    * Type: Process Builder
    * Name: Contact Processes
    * Node: SMS Opt In
    * Scenario: sms opt out set to false on contact, create consent record with send confirmation message set to false
    */  
    @isTest
    static void testSMSOptInCase(){
        list<Contact> conList = new List<Contact>();
        conList = [select id,smagicinteract__SMSOptOut__c from Contact];
        Boolean smsOptOut=conList[0].smagicinteract__SMSOptOut__c;
        conList[0].smagicinteract__SMSOptOut__c = false;
        test.startTest();
        update conList;
        test.stopTest();
        List<smagicinteract__Consent__c> consent = [Select Id,smagicinteract__Compliance_Status__c,smagicinteract__Do_Not_Send_Confirmation__c,smagicinteract__Send_Confirmation_Message__c from smagicinteract__Consent__c where smagicinteract__Contact__c =:conList[0].Id];
        system.assertEquals(consent[0].smagicinteract__Send_Confirmation_Message__c,false,'Send Confirmation Message' );
        
    }
}
@isTest
public with sharing class FlowTest_AccountProcesses {
    @TestSetup
    static void createAccount(){
        Account acc =  new Data.AccountBuilder()
        .newAccount()
        .setFirstName('Dan')
        .setLastName('Smith')
        .setPersonmailingCountry('United States')
        .setPersonMailingState('Minnesota')
        .setPersonMailingStateCode('MN')
        .setMailingStreet1('4206 Minnesota')
        .setMailingStreet2('Pine Apt. 165')
        .doInsert()
        .account;
    }

    /*
    * Type: Process Builder
    * Name: Account Process
    * Node: Opt Out Cases
    * Scenario: Consent to text set to No, should set SMS Opt Out checkbox
    */
    @isTest
    static void testPatientSMSConsentOptOutCase(){
        list<Account> accList = new List<Account>();
        accList = [select id,Consent_To_Text__c from Account];
        string consentToText=accList[0].Consent_To_Text__c;
        accList[0].Consent_To_Text__c = 'No';
        test.startTest();
        update accList;
        test.stopTest();
        system.assertEquals([select smagicinteract__SMSOptOut__pc from account][0].smagicinteract__SMSOptOut__pc,true );
        
    }

    /*
    * Type: Process Builder
    * Name: Account Process
    * Node: Opt Out Cases
    * Scenario: Consent to text set to Yes, should not set SMS Opt Out checkbox
    */
    @isTest
    static void testPatientSMSConsentOptInCase(){
        list<Account> accList = new List<Account>();
        accList = [select id,Consent_To_Text__c from Account];
        string consentToText=accList[0].Consent_To_Text__c;
        accList[0].Consent_To_Text__c = 'Yes';
        test.startTest();
        update accList;
        test.stopTest();
        system.assertEquals([select smagicinteract__SMSOptOut__pc from account][0].smagicinteract__SMSOptOut__pc,false);
        
    }

    /*
    * Type: Process Builder
    * Name: Account Process
    * Node: Patient SMS Consent
    * Scenario: Consent to text empty, should not set SMS Opt Out checkbox
    */
    @isTest
    static void testPatientSMSConsentNegativeCase(){
        list<Account> accList = new List<Account>();
        accList = [select id,Consent_To_Text__c from Account];
        string consentToText=accList[0].Consent_To_Text__c;
        accList[0].Consent_To_Text__c = null;
        test.startTest();
        update accList;
        test.stopTest();
        system.assertEquals([select smagicinteract__SMSOptOut__pc from account][0].smagicinteract__SMSOptOut__pc,true);
        
    }

    /*
    * Type: Process Builder
    * Name: Account Process
    * Node: Update Address
    * Scenario: PersonMailingStreet on Account blank, Mailing Street 1 on Account is changed,
    * should update PersonMailingStreet with Mailing Street 1
    */
    @isTest
    static void testUpdateAddressPositiveCase(){
        list<Account> accList = new List<Account>();
        accList = [select id,PersonMailingStreet,Mailing_Street_1__c,Mailing_Street_2__c from Account];
        accList[0].Mailing_Street_1__c = '4207 Minnesota';
        accList[0].PersonMailingStreet = '';
        test.startTest();
        update accList;
        List<Account> updatedAcc = new List<Account>();
        updatedAcc = [select id,PersonMailingStreet,Mailing_Street_1__c,Mailing_Street_2__c from Account where Id =:accList[0].Id];
        String mailingAddress = updatedAcc[0].Mailing_Street_1__c;
        test.stopTest();
        system.assertEquals(updatedAcc[0].PersonMailingStreet,mailingAddress);
        
    }

    /*
    * Type: Process Builder
    * Name: Account Process
    * Node: Update Address
    * Scenario: PersonMailingStreet on Account is not blank
    * should not update PersonMailingStreet with Mailing Street 1
    */
    @isTest
    static void testUpdateAddressNegativeCase(){
        list<Account> accList = new List<Account>();
        accList = [select id,PersonMailingStreet,Mailing_Street_1__c,Mailing_Street_2__c from Account];
        accList[0].PersonMailingStreet = 'Test Mailing Street';
        String personalMailingStreet = accList[0].PersonMailingStreet;
        test.startTest();
        update accList;
        test.stopTest();
        system.assertEquals([select PersonMailingStreet from account][0].PersonMailingStreet,personalMailingStreet);
        
    }
    
    /*
    * Type: Process Builder
    * Name: Account Process
    * Node: Person/Region: Midwest - CT
    * Scenario: Person Account, PersonMailingState set to Minnesota, PersonMailingStateCode set to MN
    */
    @isTest
    static void testPersonMidwestCT(){
        list<Account> accList = new List<Account>();
        accList = [select id,PersonMailingStreet,Mailing_Street_1__c,Mailing_Street_2__c from Account];
        accList[0].PersonMailingStreet = 'Test Mailing Street';
        accList[0].PersonMailingState = 'Minnesota';
        accList[0].PersonMailingStateCode = 'MN';
        String personalMailingStreet = accList[0].PersonMailingStreet;
        
        sked__Region__c region = new Data.RegionBuilder()
        .newRegion()
        .setTimeZone('US/Central')
        .setDescription('MN')
        .doInsert()
        .region;

        
        test.startTest();
        update accList;
        test.stopTest();        
    }
    
    /*
    * Type: Process Builder
    * Name: Account Process
    * Node: Person/Region: Midwest - ET
    * Scenario: Person Account, PersonMailingState set to Indiana, PersonMailingStateCode set to IN
    */
    @isTest
    static void testPersonMidwestET(){
        list<Account> accList = new List<Account>();
        accList = [select id,PersonMailingStreet,Mailing_Street_1__c,Mailing_Street_2__c from Account];
        accList[0].PersonMailingStreet = 'Test Mailing Street';
        accList[0].PersonMailingState = 'Indiana';
        accList[0].PersonMailingStateCode = 'IN';
        String personalMailingStreet = accList[0].PersonMailingStreet;
        
        sked__Region__c region = new Data.RegionBuilder()
        .newRegion()
        .setTimeZone('US/Central')
        .setDescription('IN')
        .doInsert()
        .region;
        
        test.startTest();
        update accList;
        test.stopTest();        
    }
    
    /*
    * Type: Process Builder
    * Name: Account Process
    * Node: Person/Region: Northeast
    * Scenario: Person Account, PersonMailingState set to New York, PersonMailingStateCode set to NY
    */
    @isTest
    static void testPersonNorthEast(){
        list<Account> accList = new List<Account>();
        accList = [select id,PersonMailingStreet,Mailing_Street_1__c,Mailing_Street_2__c from Account];
        accList[0].PersonMailingStreet = 'Test Mailing Street';
        accList[0].PersonMailingState = 'New York';
        accList[0].PersonMailingStateCode = 'NY';
        String personalMailingStreet = accList[0].PersonMailingStreet;
        
        sked__Region__c region = new Data.RegionBuilder()
        .newRegion()
        .setTimeZone('US/Central')
        .setDescription('NY')
        .doInsert()
        .region;
        
        test.startTest();
        update accList;
        test.stopTest();        
    }
    
    /*
    * Type: Process Builder
    * Name: Account Process
    * Node: Person/Region: Southeast - CT
    * Scenario: Person Account, PersonMailingState set to Alabama, PersonMailingStateCode set to AL
    */
    @isTest
    static void testPersonSouthEastCT(){
        list<Account> accList = new List<Account>();
        accList = [select id,PersonMailingStreet,Mailing_Street_1__c,Mailing_Street_2__c from Account];
        accList[0].PersonMailingStreet = 'Test Mailing Street';
        accList[0].PersonMailingState = 'Alabama';
        accList[0].PersonMailingStateCode = 'AL';
        String personalMailingStreet = accList[0].PersonMailingStreet;
        
        sked__Region__c region = new Data.RegionBuilder()
        .newRegion()
        .setTimeZone('US/Central')
        .setDescription('AL')
        .doInsert()
        .region;
        
        test.startTest();
        update accList;
        test.stopTest();
        
    }
    
    /*
    * Type: Process Builder
    * Name: Account Process
    * Node: Person/Region: Southeast - ET
    * Scenario: Person Account, PersonMailingState set to Florida, PersonMailingStateCode set to FL
    */
    @isTest
    static void testPersonSouthEastET(){
        list<Account> accList = new List<Account>();
        accList = [select id,PersonMailingStreet,Mailing_Street_1__c,Mailing_Street_2__c from Account];
        accList[0].PersonMailingStreet = 'Test Mailing Street';
        accList[0].PersonMailingState = 'Florida';
        accList[0].PersonMailingStateCode = 'FL';
        String personalMailingStreet = accList[0].PersonMailingStreet;
        
        sked__Region__c region = new Data.RegionBuilder()
        .newRegion()
        .setTimeZone('US/Central')
        .setDescription('FL')
        .doInsert()
        .region;
        
        test.startTest();
        update accList;
        test.stopTest();        
    }
    
    /*
    * Type: Process Builder
    * Name: Account Process
    * Node: Person/Region:  Southwest - CT
    * Scenario: Person Account, PersonMailingState set to Texas, PersonMailingStateCode set to TX
    */
    @isTest
    static void testPersonSouthWestCT(){
        list<Account> accList = new List<Account>();
        accList = [select id,PersonMailingStreet,Mailing_Street_1__c,Mailing_Street_2__c from Account];
        accList[0].PersonMailingStreet = 'Test Mailing Street';
        accList[0].PersonMailingState = 'Texas';
        accList[0].PersonMailingStateCode = 'TX';
        String personalMailingStreet = accList[0].PersonMailingStreet;
        
        sked__Region__c region = new Data.RegionBuilder()
        .newRegion()
        .setTimeZone('US/Central')
        .setDescription('TX')
        .doInsert()
        .region;
        
        test.startTest();
        update accList;
        test.stopTest();        
    }
    
    /*
    * Type: Process Builder
    * Name: Account Process
    * Node: Person/Region: Southwest - MT
    * Scenario: Person Account, PersonMailingState set to Arizona, PersonMailingStateCode set to AZ
    */
    @isTest
    static void testPersonSouthWestMT(){
        list<Account> accList = new List<Account>();
        accList = [select id,PersonMailingStreet,Mailing_Street_1__c,Mailing_Street_2__c from Account];
        accList[0].PersonMailingStreet = 'Test Mailing Street';
        accList[0].PersonMailingState = 'Arizona';
        accList[0].PersonMailingStateCode = 'AZ';
        String personalMailingStreet = accList[0].PersonMailingStreet;
        
        sked__Region__c region = new Data.RegionBuilder()
        .newRegion()
        .setTimeZone('US/Central')
        .setDescription('AZ')
        .doInsert()
        .region;
        
        test.startTest();
        update accList;
        test.stopTest();        
    }
    
    /*
    * Type: Process Builder
    * Name: Account Process
    * Node: Person/Region: West - MT
    * Scenario: Person Account, PersonMailingState set to Colorado, PersonMailingStateCode set to CO
    */
    @isTest
    static void testPersonWestMT(){
        list<Account> accList = new List<Account>();
        accList = [select id,PersonMailingStreet,Mailing_Street_1__c,Mailing_Street_2__c from Account];
        accList[0].PersonMailingStreet = 'Test Mailing Street';
        accList[0].PersonMailingState = 'Colorado';
        accList[0].PersonMailingStateCode = 'CO';
        String personalMailingStreet = accList[0].PersonMailingStreet;
        
        sked__Region__c region = new Data.RegionBuilder()
        .newRegion()
        .setTimeZone('US/Central')
        .setDescription('CO')
        .doInsert()
        .region;
        
        test.startTest();
        update accList;
        test.stopTest();        
    }
    
    /*
    * Type: Process Builder
    * Name: Account Process
    * Node: Person/Region: West - PT
    * Scenario: Person Account, PersonMailingState set to California, PersonMailingStateCode set to CA
    */
    @isTest
    static void testPersonWestPT(){
        list<Account> accList = new List<Account>();
        accList = [select id,PersonMailingStreet,Mailing_Street_1__c,Mailing_Street_2__c from Account];
        accList[0].PersonMailingStreet = 'Test Mailing Street';
        accList[0].PersonMailingState = 'California';
        accList[0].PersonMailingStateCode = 'CA';
        String personalMailingStreet = accList[0].PersonMailingStreet;
        
        sked__Region__c region = new Data.RegionBuilder()
        .newRegion()
        .setTimeZone('US/Central')
        .setDescription('CA')
        .doInsert()
        .region;
        
        test.startTest();
        update accList;
        test.stopTest();        
    }
    
    /*
    * Type: Process Builder
    * Name: Account Process
    * Node: Person/Region - PR
    * Scenario: Person Account, PersonMailingState set to Puerto Rico, PersonMailingStateCode set to PR
    */
    @isTest
    static void testPersonWestPR(){
        list<Account> accList = new List<Account>();
        accList = [select id,PersonMailingStreet,Mailing_Street_1__c,Mailing_Street_2__c from Account];
        accList[0].PersonMailingStreet = 'Test Mailing Street';
        accList[0].PersonMailingState = 'Puerto Rico';
        accList[0].PersonMailingStateCode = 'PR';
        String personalMailingStreet = accList[0].PersonMailingStreet;
        
        sked__Region__c region = new Data.RegionBuilder()
        .newRegion()
        .setTimeZone('US/Central')
        .setDescription('PR')
        .doInsert()
        .region;
        
        test.startTest();
        update accList;
        test.stopTest();        
    }
}
@isTest
public with sharing class FlowTest_ResourceAvailabilityProcesses {
    @TestSetup
    static void makeData(){
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
    }

    /*
    * Type: Process Builder
    * Name: Resource Availability Processes
    * Node: Always approve
    * Scenario: whenever resource record is created or edited, status will set to approve
    */
    @isTest
    static void testAlwaysApprove(){
        Account ac = [SELECT Id,HCS_Patient_Id__c FROM Account];
        
        sked__Resource__c resource = new Data.ResourceBuilder()
        .newResource()
        .setAccount(ac.Id)
        .doInsert()
     	.resource;

        DateTime start  = System.now();
        DateTime finish = System.now().date()+1;
        sked__Availability__c availability = new Data.AvailabilityBuilder()
        .newAvailability()
        .setIsAvailable(true)
        .setType('Availability')
        .setResource(resource.Id)
        .setStart(start)
        .setFinish(finish)
        .doInsert()
        .availability;
        System.assertEquals('Approved',[Select Id,sked__Status__c from sked__Availability__c].sked__Status__c);
    }
}
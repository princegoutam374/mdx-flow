@isTest
public with sharing class FlowTest_JobProcesses {
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
        .doInsert()
        .account;
        
        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ZEPOSIA - GASTRO').getRecordTypeId();
        Case cs = new Data.CaseBuilder()
        .newCase()
        .setAccountId(acc.Id)
        .setRecordTypeId(recordTypeId)
        .doInsert()
        .cs;

        sked__Region__c region = new Data.RegionBuilder()
        .newRegion()
        .setTimeZone('Australia/Brisbane')
        .doInsert()
        .region;

        sked__Job__c jb = new Data.JobBuilder()
        .newJob()
        .setDuration(10)
        .setRegion(region.Id)
        .setCase(cs.Id)
        .doInsert()
        .job;
    }

    /*
    * Type: Process Builder
    * Name: Job Processes
    * Node: ISNEW()
    * Scenario: Whenever a job record is created or edited with the Case assigned to it of record type ZEPOSIA - GASTRO, then
    * Job field on case will be updated with job id
    */
    @isTest
    static void testNewJobPositiveScenario(){    
        list<sked__Job__c> jobList = new List<sked__Job__c>();
        jobList = [select id from sked__Job__c];
        system.assertEquals([select Job__c from Case][0].Job__c,jobList[0].Id,'Patient Opt Out of SMS' );
        
    }
    
    /*
    * Type: Process Builder
    * Name: Job Processes
    * Node: ISNEW()
    * Scenario: Whenever a job record is created or edited with the Case assigned to it of not record type ZEPOSIA - GASTRO, then
    * Job field on case will be not updated with job id
    */
    @isTest
    static void testNewJobNegativeScenario(){
        List<Account> acc = [Select Id from Account Limit 1];
        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ZEPOSIA ECG Loaner Program').getRecordTypeId();
        Case cs = new Case();
        cs.AccountId = acc[0].Id;
        cs.RecordTypeId = recordTypeId;
        insert cs;
        
        list<sked__Job__c> jobList = new List<sked__Job__c>();
        jobList = [select id from sked__Job__c];
        system.assertNotEquals(null,jobList,'Patient Opt Out of SMS' );
        
    }
    
    /*
    * Type: Process Builder
    * Name: Job Processes
    * Node: Field Updates
    * Scenario: Notes or Notes Comments is changed, then update the notes field on case with the job notes field
    */
    @isTest
    static void testFieldUpdatesPositiveScenario(){
        List<sked__Job__c> jobList = [select id,Notes__c,sked__Notes_Comments__c,sked__Start__c from sked__Job__c];
        jobList[0].Notes__c = 'Test Job';
        jobList[0].sked__Notes_Comments__c = 'Test Notes Comment';
        update jobList;
        
        List<Case> caseList = [Select Id, Appointment_Date_Time__c,Notes__c from Case];
        System.assertEquals(caseList[0].Notes__c, jobList[0].sked__Notes_Comments__c);
    }
    
    /*
    * Type: Process Builder
    * Name: Job Processes
    * Node: Field Updates
    * Scenario: Notes or Notes Comments is changed, but case is not assigned, then nothing will be updated on Case
    */
    @isTest
    static void testFieldUpdatesNegativeScenario(){
        List<sked__Job__c> jobList = [select id,Notes__c,sked__Notes_Comments__c,sked__Start__c, Case__c from sked__Job__c];
        jobList[0].Notes__c = 'Test Job';
        jobList[0].Case__c = null;
        jobList[0].sked__Notes_Comments__c = 'Test Notes Comment';
        update jobList;        
        List<Case> caseList = [Select Id, Appointment_Date_Time__c,Notes__c from Case];
        System.assertNotEquals(caseList[0].Notes__c, jobList[0].sked__Notes_Comments__c);
    }
    
    /*
    * Type: Process Builder
    * Name: Job Processes
    * Node: En Route
    * Scenario: Job Status set to En Route, then Status of Case should be set to Appointment
    */
    @isTest
    static void testEnRoutePositiveScenario(){
        List<sked__Job__c> jobList = [select id,sked__Job_Status__c, Case__c from sked__Job__c];
        jobList[0].sked__Job_Status__c = 'En Route';
        update jobList;   
        
        List<Case> caseList = [Select Id,Status from Case where Id =: jobList[0].Case__c];
        System.assertEquals(caseList[0].Status, 'Appointment');
    }
    
    /*
    * Type: Process Builder
    * Name: Job Processes
    * Node: En Route
    * Scenario: Job Status set not to En Route, then Status of Case should not be set to Appointment
    */
    @isTest
    static void testEnRouteNegativeScenario(){
        List<sked__Job__c> jobList = [select id,sked__Job_Status__c, Case__c from sked__Job__c];
        jobList[0].sked__Job_Status__c = 'Queued';
        update jobList;   
        
        List<Case> caseList = [Select Id,Status from Case where Id =: jobList[0].Case__c];
        System.assertNotEquals(caseList[0].Status, 'Appointment');
    }
    
    /*
    * Type: Process Builder
    * Name: Job Processes
    * Node: Job Cancelled
    * Scenario: Job Status set to Cancelled, then Cancel Case field on Case should be set to true and Abort reason to abort reason of job
    */
    @isTest
    static void testJobCancelledPositiveScenario(){
        List<sked__Job__c> jobList = [select id,sked__Job_Status__c, Case__c,sked__Abort_Reason__c from sked__Job__c];
        jobList[0].sked__Job_Status__c = 'Cancelled';
        jobList[0].sked__Abort_Reason__c = 'Other';
        update jobList;   
        
        List<Case> caseList = [Select Id,Cancel_Case__c,Abort_Reason_picklist__c from Case where Id =: jobList[0].Case__c];
        System.assertEquals(caseList[0].Cancel_Case__c, true);
        System.assertEquals(caseList[0].Abort_Reason_picklist__c, jobList[0].sked__Abort_Reason__c);
    }
    
    /*
    * Type: Process Builder
    * Name: Job Processes
    * Node: Job Cancelled
    * Scenario: Job Status not set to Cancelled, then Cancel Case field on Case should not be set to true and Abort reason not to abort reason of job
    */
    @isTest
    static void testJobCancelledNegativeScenario(){
        List<sked__Job__c> jobList = [select id,sked__Job_Status__c, Case__c,sked__Abort_Reason__c from sked__Job__c];
        jobList[0].sked__Job_Status__c = 'Queued';
        jobList[0].sked__Abort_Reason__c = 'Other';
        update jobList;   
        
        List<Case> caseList = [Select Id,Cancel_Case__c,Abort_Reason_picklist__c from Case where Id =: jobList[0].Case__c];
        System.assertNotEquals(caseList[0].Cancel_Case__c, true);
        System.assertNotEquals(caseList[0].Abort_Reason_picklist__c, jobList[0].sked__Abort_Reason__c);
    }
    
    /*
    * Type: Process Builder
    * Name: Job Processes
    * Node: Job Completed
    * Scenario: Job Status set to Completed, then Complete Case field on Case should be set to true
    */
    @isTest
    static void testJobCompletePositiveScenario(){
        List<sked__Job__c> jobList = [select id,sked__Job_Status__c, Case__c from sked__Job__c];
        jobList[0].sked__Job_Status__c = 'Complete';
        update jobList;   
        
        List<Case> caseList = [Select Id,Complete_Case__c from Case where Id =: jobList[0].Case__c];
        System.assertEquals(caseList[0].Complete_Case__c, true);
    }
    
    /*
    * Type: Process Builder
    * Name: Job Processes
    * Node: Job Completed
    * Scenario: Job Status not set to Completed, then Complete Case field on Case should not be set to true
    */
    @isTest
    static void testJobCompletedNegativeScenario(){
        List<sked__Job__c> jobList = [select id,sked__Job_Status__c, Case__c from sked__Job__c];
        jobList[0].sked__Job_Status__c = 'Queued';
        update jobList;   
        
        List<Case> caseList = [Select Id,Complete_Case__c from Case where Id =: jobList[0].Case__c];
        System.assertNotEquals(caseList[0].Complete_Case__c, true);
    }
}